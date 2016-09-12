# This file originates from node2nix

{stdenv, python, nodejs, utillinux, runCommand, writeTextFile}:

let
  # Create a tar wrapper that filters all the 'Ignoring unknown extended header keyword' noise
  tarWrapper = runCommand "tarWrapper" {} ''
    mkdir -p $out/bin
    
    cat > $out/bin/tar <<EOF
    #! ${stdenv.shell} -e
    $(type -p tar) "\$@" --warning=no-unknown-keyword
    EOF
    
    chmod +x $out/bin/tar
  '';
  
  # Function that generates a TGZ file from a NPM project
  buildNodeSourceDist =
    { name, version, src, ... }:
    
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

  includeDependencies = {dependencies}:
    stdenv.lib.optionalString (dependencies != [])
      (stdenv.lib.concatMapStrings (dependency:
        ''
          # Bundle the dependencies of the package
          mkdir -p node_modules
          cd node_modules
          
          # Only include dependencies if they don't exist. They may also be bundled in the package.
          if [ ! -e "${dependency.name}" ]
          then
              ${composePackage dependency}
          fi
          
          cd ..
        ''
      ) dependencies);

  # Recursively composes the dependencies of a package
  composePackage = { name, packageName, src, dependencies ? [], ... }@args:
    let
      fixImpureDependencies = writeTextFile {
        name = "fixDependencies.js";
        text = ''
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
        '';
      };
    in
    ''
      DIR=$(pwd)
      cd $TMPDIR
      
      unpackFile ${src}
      
      # Make the base dir in which the target dependency resides first
      mkdir -p "$(dirname "$DIR/${packageName}")"

      if [ -f "${src}" ]
      then
          # Figure out what directory has been unpacked
          packageDir=$(find . -type d -maxdepth 1 | tail -1)
          
          # Restore write permissions to make building work
          find "$packageDir" -type d -print0 | xargs -0 chmod u+x
          chmod -R u+w "$packageDir"
          
          # Move the extracted tarball into the output folder
          mv "$packageDir" "$DIR/${packageName}"
      elif [ -d "${src}" ]
      then
          # Restore write permissions to make building work
          chmod -R u+w $strippedName
          
          # Move the extracted directory into the output folder
          mv $strippedName "$DIR/${packageName}"
      fi

      # Unset the stripped name to not confuse the next unpack step
      unset strippedName
      
      # Some version specifiers (latest, unstable, URLs, file paths) force NPM to make remote connections or consult paths outside the Nix store.
      # The following JavaScript replaces these by * to prevent that
      cd "$DIR/${packageName}"
      node ${fixImpureDependencies}
      
      # Include the dependencies of the package
      ${includeDependencies { inherit dependencies; }}
      cd ..
      ${stdenv.lib.optionalString (builtins.substring 0 1 packageName == "@") "cd .."}
    '';

  # Extract the Node.js source code which is used to compile packages with
  # native bindings
  nodeSources = runCommand "node-sources" {} ''
    tar --no-same-owner --no-same-permissions -xf ${nodejs.src}
    mv node-* $out
  '';
  
  # Builds and composes an NPM package including all its dependencies
  buildNodePackage = { name, packageName, version, dependencies ? [], production ? true, npmFlags ? "", dontNpmInstall ? false, preRebuild ? "", ... }@args:
    
    stdenv.lib.makeOverridable stdenv.mkDerivation (builtins.removeAttrs args [ "dependencies" ] // {
      name = "node-${name}-${version}";
      buildInputs = [ tarWrapper python nodejs ] ++ stdenv.lib.optional (stdenv.isLinux) utillinux ++ args.buildInputs or [];
      dontStrip = args.dontStrip or true; # Striping may fail a build for some package deployments
      
      inherit dontNpmInstall preRebuild;
      
      unpackPhase = args.unpackPhase or "true";
      
      buildPhase = args.buildPhase or "true";
      
      compositionScript = composePackage args;
      passAsFile = [ "compositionScript" ];
      
      installPhase = args.installPhase or ''
        # Create and enter a root node_modules/ folder
        mkdir -p $out/lib/node_modules
        cd $out/lib/node_modules
          
        # Compose the package and all its dependencies
        source $compositionScriptPath
        
        # Patch the shebangs of the bundled modules to prevent them from
        # calling executables outside the Nix store as much as possible
        patchShebangs .
        
        # Deploy the Node.js package by running npm install. Since the
        # dependencies have been provided already by ourselves, it should not
        # attempt to install them again, which is good, because we want to make
        # it Nix's responsibility. If it needs to install any dependencies
        # anyway (e.g. because the dependency parameters are
        # incomplete/incorrect), it fails.
        #
        # The other responsibilities of NPM are kept -- version checks, build
        # steps, postprocessing etc.
        
        export HOME=$TMPDIR
        cd "${packageName}"
        runHook preRebuild
        npm --registry http://www.example.com --nodedir=${nodeSources} ${npmFlags} ${stdenv.lib.optionalString production "--production"} rebuild
        
        if [ "$dontNpmInstall" != "1" ]
        then
            npm --registry http://www.example.com --nodedir=${nodeSources} ${npmFlags} ${stdenv.lib.optionalString production "--production"} install
        fi
        
        # Create symlink to the deployed executable folder, if applicable
        if [ -d "$out/lib/node_modules/.bin" ]
        then
            ln -s $out/lib/node_modules/.bin $out/bin
        fi
        
        # Create symlinks to the deployed manual page folders, if applicable
        if [ -d "$out/lib/node_modules/${packageName}/man" ]
        then
            mkdir -p $out/share
            for dir in "$out/lib/node_modules/${packageName}/man/"*
            do
                mkdir -p $out/share/man/$(basename "$dir")
                for page in "$dir"/*
                do
                    ln -s $page $out/share/man/$(basename "$dir")
                done
            done
        fi
      '';
    });

  # Builds a development shell
  buildNodeShell = { name, packageName, version, src, dependencies ? [], production ? true, npmFlags ? "", dontNpmInstall ? false, ... }@args:
    let
      nodeDependencies = stdenv.mkDerivation {
        name = "node-dependencies-${name}-${version}";
        
        buildInputs = [ tarWrapper python nodejs ] ++ stdenv.lib.optional (stdenv.isLinux) utillinux ++ args.buildInputs or [];
        
        includeScript = includeDependencies { inherit dependencies; };
        passAsFile = [ "includeScript" ];
        
        buildCommand = ''
          mkdir -p $out/lib
          cd $out/lib
          source $includeScriptPath
          
          # Create fake package.json to make the npm commands work properly
          cat > package.json <<EOF
          {
              "name": "${packageName}",
              "version": "${version}"
          }
          EOF
          
          # Patch the shebangs of the bundled modules to prevent them from
          # calling executables outside the Nix store as much as possible
          patchShebangs .
          
          export HOME=$TMPDIR
          npm --registry http://www.example.com --nodedir=${nodeSources} ${npmFlags} ${stdenv.lib.optionalString production "--production"} rebuild
          
          ${stdenv.lib.optionalString (!dontNpmInstall) ''
            npm --registry http://www.example.com --nodedir=${nodeSources} ${npmFlags} ${stdenv.lib.optionalString production "--production"} install
          ''}

          ln -s $out/lib/node_modules/.bin $out/bin
        '';
      };
    in
    stdenv.lib.makeOverridable stdenv.mkDerivation {
      name = "node-shell-${name}-${version}";
      
      buildInputs = [ python nodejs ] ++ stdenv.lib.optional (stdenv.isLinux) utillinux ++ args.buildInputs or [];
      buildCommand = ''
        mkdir -p $out/bin
        cat > $out/bin/shell <<EOF
        #! ${stdenv.shell} -e
        $shellHook
        exec ${stdenv.shell}
        EOF
        chmod +x $out/bin/shell
      '';
      
      # Provide the dependencies in a development shell through the NODE_PATH environment variable
      inherit nodeDependencies;
      shellHook = stdenv.lib.optionalString (dependencies != []) ''
        export NODE_PATH=$nodeDependencies/lib/node_modules
      '';
    };
in
{ inherit buildNodeSourceDist buildNodePackage buildNodeShell; }
