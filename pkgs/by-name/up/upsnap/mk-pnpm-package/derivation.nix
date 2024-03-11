# source is <https://github.com/nzbr/pnpm2nix-nzbr/blob/main/derivation.nix>

{ lib
, stdenv
, nodejs
, pkg-config
, callPackage
, writeText
, runCommand
, ...
}:

with builtins; with lib; with callPackage ./lockfile.nix { };
let
  nodePkg = nodejs;
  pkgConfigPkg = pkg-config;
in
{
  mkPnpmPackage =
    { src
    , packageJSON ? src + "/package.json"
    , pnpmLockYaml ? src + "/pnpm-lock.yaml"
    , pname ? (fromJSON (readFile packageJSON)).name
    , version ? (fromJSON (readFile packageJSON)).version or null
    , name ? if version != null then "${pname}-${version}" else pname
    , registry ? "https://registry.npmjs.org"
    , script ? "build"
    , distDir ? "dist"
    , installInPlace ? false
    , installEnv ? { }
    , noDevDependencies ? false
    , extraNodeModuleSources ? [ ]
    , copyPnpmStore ? true
    , copyNodeModules ? false
    , extraBuildInputs ? [ ]
    , nodejs ? nodePkg
    , pnpm ? nodejs.pkgs.pnpm
    , pkg-config ? pkgConfigPkg
    , ...
    }@attrs:
    let
      nativeBuildInputs = [
        nodejs
        pnpm
        pkg-config
      ] ++ extraBuildInputs;
    in
    stdenv.mkDerivation (
      recursiveUpdate
        (rec {
          inherit src name nativeBuildInputs;

          configurePhase = ''
            export HOME=$NIX_BUILD_TOP # Some packages need a writable HOME
            export npm_config_nodedir=${nodejs}

            runHook preConfigure

            ${if installInPlace
              then passthru.nodeModules.buildPhase
              else ''
                ${if !copyNodeModules
                  then "ln -s"
                  else "cp -r"
                } ${passthru.nodeModules}/node_modules node_modules
              ''
            }

            runHook postConfigure
          '';

          buildPhase = ''
            runHook preBuild

            pnpm run ${script}

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            ${if distDir == "." then "cp -r" else "mv"} ${distDir} $out

            runHook postInstall
          '';

          passthru =
            let
              processResult = processLockfile { inherit registry noDevDependencies; lockfile = pnpmLockYaml; };
            in
            {
              inherit attrs;

              patchedLockfile = processResult.patchedLockfile;
              patchedLockfileYaml = writeText "pnpm-lock.yaml" (toJSON passthru.patchedLockfile);

              pnpmStore = runCommand "${name}-pnpm-store"
                {
                  nativeBuildInputs = [ nodejs pnpm ];
                } ''
                mkdir -p $out

                store=$(pnpm store path)
                mkdir -p $(dirname $store)
                ln -s $out $(pnpm store path)

                pnpm store add ${concatStringsSep " " (unique processResult.dependencyTarballs)}
              '';

              nodeModules = stdenv.mkDerivation {
                name = "${name}-node-modules";

                inherit nativeBuildInputs;

                unpackPhase = concatStringsSep "\n"
                  (
                    map
                      (v:
                        let
                          nv = if isAttrs v then v else { name = "."; value = v; };
                        in
                        "cp -vr ${nv.value} ${nv.name}"
                      )
                      ([
                        { name = "package.json"; value = packageJSON; }
                        { name = "pnpm-lock.yaml"; value = passthru.patchedLockfileYaml; }
                      ] ++ extraNodeModuleSources)
                  );

                buildPhase = ''
                  export HOME=$NIX_BUILD_TOP # Some packages need a writable HOME

                  store=$(pnpm store path)
                  mkdir -p $(dirname $store)

                  cp -f ${passthru.patchedLockfileYaml} pnpm-lock.yaml

                  # solve pnpm: EACCES: permission denied, copyfile '/build/.pnpm-store
                  ${if !copyPnpmStore
                    then "ln -s"
                    else "cp -RL"
                  } ${passthru.pnpmStore} $(pnpm store path)

                  ${lib.optionalString copyPnpmStore "chmod -R +w $(pnpm store path)"}

                  ${concatStringsSep "\n" (
                    mapAttrsToList
                      (n: v: ''export ${n}="${v}"'')
                      installEnv
                  )}

                  pnpm install ${optionalString noDevDependencies "--prod "}--frozen-lockfile --offline
                '';

                installPhase = ''
                  mkdir -p $out
                  cp -r node_modules/. $out/node_modules
                '';
              };
            };

        })
        (attrs // { extraNodeModuleSources = null; installEnv = null; })
    );
}

