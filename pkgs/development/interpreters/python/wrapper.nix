{
  lib,
  stdenv,
  buildEnv,
  runCommand,
  makeBinaryWrapper,

  # manually pased
  python,
  requiredPythonModules,

  # extra opts
  extraLibs ? [ ],
  extraOutputsToInstall ? [ ],
  postBuild ? "",
  ignoreCollisions ? false,
  permitUserSite ? false,
  # Wrap executables with the given argument.
  makeWrapperArgs ? [ ],
}:

# Create a python executable that knows about additional packages.
let
  env =
    let
      paths = requiredPythonModules (extraLibs ++ [ python ]) ++ [
        (runCommand "bin" { } ''
          mkdir -p $out/bin
        '')
      ];
      pythonPath = "${placeholder "out"}/${python.sitePackages}";
      pythonExecutable = "${placeholder "out"}/bin/${python.executable}";
    in
    buildEnv {
      name = "${python.name}-env";

      inherit paths;
      inherit ignoreCollisions;
      extraOutputsToInstall = [ "out" ] ++ extraOutputsToInstall;

      nativeBuildInputs = [ makeBinaryWrapper ];

      postBuild = ''
        for path in ${lib.concatStringsSep " " paths}; do
          if [ -d "$path/bin" ]; then
            cd "$path/bin"
            for prg in *; do
              if [ -f "$prg" ] && [ -x "$prg" ]; then
                rm -f "$out/bin/$prg"
                if [ "$prg" = "${python.executable}" ]; then
                  makeWrapper "${python.interpreter}" "$out/bin/$prg" \
                    --inherit-argv0 \
                    ${lib.optionalString (!permitUserSite) ''--set PYTHONNOUSERSITE "true"''} \
                    ${lib.concatStringsSep " " makeWrapperArgs}
                elif [ "$(readlink "$prg")" = "${python.executable}" ]; then
                  ln -s "${python.executable}" "$out/bin/$prg"
                else
                  makeWrapper "$path/bin/$prg" "$out/bin/$prg" \
                    --set NIX_PYTHONPREFIX "$out" \
                    --set NIX_PYTHONEXECUTABLE ${pythonExecutable} \
                    --set NIX_PYTHONPATH ${pythonPath} \
                    ${lib.optionalString (!permitUserSite) ''--set PYTHONNOUSERSITE "true"''} \
                    ${lib.concatStringsSep " " makeWrapperArgs}
                fi
              fi
            done
          fi
        done
      ''
      + postBuild;

      inherit (python) meta;

      passthru = python.passthru // {
        interpreter = "${env}/bin/${python.executable}";
        inherit python;
        env = stdenv.mkDerivation {
          name = "interactive-${python.name}-environment";
          nativeBuildInputs = [ env ];

          buildCommand = ''
            echo >&2 ""
            echo >&2 "*** Python 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
            echo >&2 ""
            exit 1
          '';
        };
      };
    };
in
env
