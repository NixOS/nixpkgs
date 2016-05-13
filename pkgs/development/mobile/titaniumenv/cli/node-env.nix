{ stdenv, fetchurl, nodejs, python, utillinux, runCommand }:

let
  # Function that generates a TGZ file from a NPM project
  buildNodeSourceDist =
    { name, version, src }:

    stdenv.mkDerivation {
      name = "node-tarball-${name}-${version}";
      inherit src;
      buildInputs = [ nodejs ];
      buildPhase = ''
        export HOME=$TMPDIR
        tgzFile=$(npm pack)
      '';
      installPhase = ''
        mkdir -p $out/tarballs
        mv $tgzFile $out/tarballs
        mkdir -p $out/nix-support
        echo "file source-dist $out/tarballs/$tgzFile" >> $out/nix-support/hydra-build-products
      '';
    };

  # We must run semver to determine whether a provided dependency conforms to a certain version range
  semver = buildNodePackage {
    name = "semver";
    version = "5.0.3";
    src = fetchurl {
      url = http://registry.npmjs.org/semver/-/semver-5.0.3.tgz;
      sha1 = "77466de589cd5d3c95f138aa78bc569a3cb5d27a";
    };
  } {};

  # Function that produces a deployed NPM package in the Nix store
  buildNodePackage =
    { name, version, src, dependencies ? {}, buildInputs ? [], production ? true, npmFlags ? "", meta ? {}, linkDependencies ? false }:
    { providedDependencies ? {} }:

    let
      # Generate and import a Nix expression that determines which dependencies
      # are required and which are not required (and must be shimmed).
      #
      # It uses the semver utility to check whether a version range matches any
      # of the provided dependencies.

      analysedDependencies =
        if dependencies == {} then {}
        else
          import (stdenv.mkDerivation {
            name = "${name}-${version}-analysedDependencies.nix";
            buildInputs = [ semver ];
            buildCommand = ''
              cat > $out <<EOF
              {
              ${stdenv.lib.concatMapStrings (dependencyName:
                let
                  dependency = builtins.getAttr dependencyName dependencies;
                  versionSpecs = builtins.attrNames dependency;
                in
                stdenv.lib.concatMapStrings (versionSpec:
                  if builtins.hasAttr dependencyName providedDependencies # Search for any provided dependencies that match the required version spec. If one matches, the dependency should not be included
                  then
                    let
                      providedDependency = builtins.getAttr dependencyName providedDependencies;
                      versions = builtins.attrNames providedDependency;

                      # If there is a version range match, add the dependency to
                      # the set of shimmed dependencies.
                      # Otherwise, it is a required dependency.
                    in
                    ''
                      $(latestVersion=$(semver -r '${versionSpec}' ${stdenv.lib.concatMapStrings (version: " '${version}'") versions} | tail -1 | tr -d '\n')

                      if semver -r '${versionSpec}' ${stdenv.lib.concatMapStrings (version: " '${version}'") versions} >/dev/null
                      then
                          echo "shimmedDependencies.\"${dependencyName}\".\"$latestVersion\" = true;"
                      else
                          echo 'requiredDependencies."${dependencyName}"."${versionSpec}" = true;'
                      fi)
                    ''
                  else # If a dependency is not provided by an includer, we must always include it ourselves
                    "requiredDependencies.\"${dependencyName}\".\"${versionSpec}\" = true;\n"
                ) versionSpecs
              ) (builtins.attrNames dependencies)}
              }
              EOF
            '';
          });

      requiredDependencies = analysedDependencies.requiredDependencies or {};
      shimmedDependencies = analysedDependencies.shimmedDependencies or {};

      # Extract the Node.js source code which is used to compile packages with native bindings
      nodeSources = runCommand "node-sources" {} ''
        tar --no-same-owner --no-same-permissions -xf ${nodejs.src}
        mv node-* $out
      '';

      # Compose dependency information that this package must propagate to its
      # dependencies, so that provided dependencies are not included a second time.
      # This prevents cycles and wildcard version mismatches.

      propagatedProvidedDependencies =
        (stdenv.lib.mapAttrs (dependencyName: dependency:
          builtins.listToAttrs (map (versionSpec:
            { name = dependency."${versionSpec}".version;
              value = true;
            }
          ) (builtins.attrNames dependency))
        ) dependencies) //
        providedDependencies //
        { "${name}"."${version}" = true; };

      # Create a node_modules folder containing all required dependencies of the
      # package

      nodeDependencies = stdenv.mkDerivation {
        name = "node-dependencies-${name}-${version}";
        inherit src;
        buildCommand = ''
          mkdir -p $out/lib/node_modules
          cd $out/lib/node_modules

          # Create copies of (or symlinks to) the dependencies that must be deployed in this package's private node_modules folder.
          # This package's private dependencies are NPM packages that have not been provided by any of the includers.

          ${stdenv.lib.concatMapStrings (requiredDependencyName:
            stdenv.lib.concatMapStrings (versionSpec:
              let
                dependency = dependencies."${requiredDependencyName}"."${versionSpec}".pkg {
                  providedDependencies = propagatedProvidedDependencies;
                };
              in
              ''
                depPath=$(echo ${dependency}/lib/node_modules/*)

                ${if linkDependencies then ''
                  ln -s $depPath .
                '' else ''
                  cp -r $depPath .
                ''}
              ''
            ) (builtins.attrNames (requiredDependencies."${requiredDependencyName}"))
          ) (builtins.attrNames requiredDependencies)}
        '';
      };

      # Deploy the Node package with some tricks
      self = stdenv.lib.makeOverridable stdenv.mkDerivation {
        inherit src meta;
        dontStrip = true;

        name = "node-${name}-${version}";
        buildInputs = [ nodejs python ] ++ stdenv.lib.optional (stdenv.isLinux) utillinux ++ buildInputs;
        dontBuild = true;

        installPhase = ''
          # Move the contents of the tarball into the output folder
          mkdir -p "$out/lib/node_modules/${name}"
          mv * "$out/lib/node_modules/${name}"

          # Enter the target directory
          cd "$out/lib/node_modules/${name}"

          # Patch the shebangs of the bundled modules. For "regular" dependencies
          # this is step is not required, because it has already been done by the generic builder.

          if [ -d node_modules ]
          then
              patchShebangs node_modules
          fi

          # Copy the required dependencies
          mkdir -p node_modules

          ${stdenv.lib.optionalString (requiredDependencies != {}) ''
            for i in ${nodeDependencies}/lib/node_modules/*
            do
                if [ ! -d "node_modules/$(basename $i)" ]
                then
                    cp -a $i node_modules
                fi
            done
          ''}

          # Create shims for the packages that have been provided by earlier includers to allow the NPM install operation to still succeed

          ${stdenv.lib.concatMapStrings (shimmedDependencyName:
            stdenv.lib.concatMapStrings (versionSpec:
              ''
                mkdir -p node_modules/${shimmedDependencyName}
                cat > node_modules/${shimmedDependencyName}/package.json <<EOF
                {
                    "name": "${shimmedDependencyName}",
                    "version": "${versionSpec}"
                }
                EOF
              ''
            ) (builtins.attrNames (shimmedDependencies."${shimmedDependencyName}"))
          ) (builtins.attrNames shimmedDependencies)}

          # Ignore npm-shrinkwrap.json for now. Ideally, it should be supported as well
          rm -f npm-shrinkwrap.json

          # Some version specifiers (latest, unstable, URLs, file paths) force NPM to make remote connections or consult paths outside the Nix store.
          # The following JavaScript replaces these by * to prevent that:

          (
          cat <<EOF
          var fs = require('fs');
          var url = require('url');

          /*
           * Replaces an impure version specification by *
           */
          function replaceImpureVersionSpec(versionSpec) {
              var parsedUrl = url.parse(versionSpec);

              if(versionSpec == "latest" || versionSpec == "unstable" ||
                  versionSpec.substr(0, 2) == ".." || dependency.substr(0, 2) == "./" || dependency.substr(0, 2) == "~/" || dependency.substr(0, 1) == '/')
                  return '*';
              else if(parsedUrl.protocol == "git:" || parsedUrl.protocol == "git+ssh:" || parsedUrl.protocol == "git+http:" || parsedUrl.protocol == "git+https:" ||
                  parsedUrl.protocol == "http:" || parsedUrl.protocol == "https:")
                  return '*';
              else
                  return versionSpec;
          }

          var packageObj = JSON.parse(fs.readFileSync('./package.json'));

          /* Replace dependencies */
          if(packageObj.dependencies !== undefined) {
              for(var dependency in packageObj.dependencies) {
                  var versionSpec = packageObj.dependencies[dependency];
                  packageObj.dependencies[dependency] = replaceImpureVersionSpec(versionSpec);
              }
          }

          /* Replace development dependencies */
          if(packageObj.devDependencies !== undefined) {
              for(var dependency in packageObj.devDependencies) {
                  var versionSpec = packageObj.devDependencies[dependency];
                  packageObj.devDependencies[dependency] = replaceImpureVersionSpec(versionSpec);
              }
          }

          /* Replace optional dependencies */
          if(packageObj.optionalDependencies !== undefined) {
              for(var dependency in packageObj.optionalDependencies) {
                  var versionSpec = packageObj.optionalDependencies[dependency];
                  packageObj.optionalDependencies[dependency] = replaceImpureVersionSpec(versionSpec);
              }
          }

          /* Write the fixed JSON file */
          fs.writeFileSync("package.json", JSON.stringify(packageObj));
          EOF
          ) | node

          # Deploy the Node.js package by running npm install. Since the dependencies have been symlinked, it should not attempt to install them again,
          # which is good, because we want to make it Nix's responsibility. If it needs to install any dependencies anyway (e.g. because the dependency
          # parameters are incomplete/incorrect), it fails.

          export HOME=$TMPDIR
          npm --registry http://www.example.com --nodedir=${nodeSources} ${npmFlags} ${stdenv.lib.optionalString production "--production"} install

          # After deployment of the NPM package, we must remove the shims again
          ${stdenv.lib.concatMapStrings (shimmedDependencyName:
            ''
              rm node_modules/${shimmedDependencyName}/package.json
              rmdir node_modules/${shimmedDependencyName}
            ''
          ) (builtins.attrNames shimmedDependencies)}

          # It makes no sense to keep an empty node_modules folder around, so delete it if this is the case
          if [ -d node_modules ]
          then
              rmdir --ignore-fail-on-non-empty node_modules
          fi

          # Create symlink to the deployed executable folder, if applicable
          if [ -d "$out/lib/node_modules/.bin" ]
          then
              ln -s $out/lib/node_modules/.bin $out/bin
          fi

          # Create symlinks to the deployed manual page folders, if applicable
          if [ -d "$out/lib/node_modules/${name}/man" ]
          then
              mkdir -p $out/share
              for dir in "$out/lib/node_modules/${name}/man/"*
              do
                  mkdir -p $out/share/man/$(basename "$dir")
                  for page in "$dir"/*
                  do
                      ln -s $page $out/share/man/$(basename "$dir")
                  done
              done
          fi
        '';

        shellHook = stdenv.lib.optionalString (requiredDependencies != {}) ''
          export NODE_PATH=${nodeDependencies}/lib/node_modules
        '';
      };
    in
    self;
in
{ inherit buildNodeSourceDist buildNodePackage; }
