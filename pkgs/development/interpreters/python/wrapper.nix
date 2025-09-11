{
  lib,
  stdenv,
  runCommand,
  buildEnv,
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
  env = buildEnv {
    name = "${python.name}-env";

    paths = requiredPythonModules (extraLibs ++ [ python ]) ++ [
      (runCommand "bin" { } ''
        mkdir -p $out/bin
      '')
    ];
    inherit ignoreCollisions;
    extraOutputsToInstall = [ "out" ] ++ extraOutputsToInstall;

    nativeBuildInputs = [ makeBinaryWrapper ];

    postBuild = ''
      rm -f "$out/bin/${python.executable}"
      makeWrapper "${python.interpreter}" "$out/bin/${python.executable}" --inherit-argv0 --resolve-argv0 ${
        lib.optionalString (!permitUserSite) ''--set PYTHONNOUSERSITE "true"''
      } ${lib.concatStringsSep " " makeWrapperArgs}
      cd ${python}/bin
      for prg in *; do
        if [ "$(readlink "$prg")" = "${python.executable}" ]; then
          rm -f "$out/bin/$prg"
          ln -s "${python.executable}" "$out/bin/$prg"
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
