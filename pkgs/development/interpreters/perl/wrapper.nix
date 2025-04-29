{
  lib,
  perl,
  buildEnv,
  makeBinaryWrapper,
  stdenv,
  extraLibs ? [ ],
  extraOutputsToInstall ? [ ],
  postBuild ? "",
  ignoreCollisions ? false,
  requiredPerlModules,
}:

# Create a perl executable that knows about additional packages.
let
  env =
    let
      paths = requiredPerlModules (extraLibs ++ [ perl ]);
    in
    buildEnv {
      name = "${perl.name}-env";

      inherit paths;
      inherit ignoreCollisions;
      extraOutputsToInstall = [ "out" ] ++ extraOutputsToInstall;

      # TODO: remove stdenv.cc as soon as it is added to propagatedNativeBuildInputs of makeBinaryWrapper
      nativeBuildInputs = [
        makeBinaryWrapper
        stdenv.cc
      ];

      # we create wrapper for the binaries in the different packages
      postBuild =
        ''
          if [ -L "$out/bin" ]; then
              unlink "$out/bin"
          fi
          mkdir -p "$out/bin"

          # take every binary from perl packages and put them into the env
          for path in ${lib.concatStringsSep " " paths}; do
            if [ -d "$path/bin" ]; then
              cd "$path/bin"
              for prg in *; do
                if [ -f "$prg" ]; then
                  rm -f "$out/bin/$prg"
                  if [ -x "$prg" ]; then
                    makeWrapper "$path/bin/$prg" "$out/bin/$prg" --suffix PERL5LIB ':' "$out/${perl.libPrefix}"
                  fi
                fi
              done
            fi
          done
        ''
        + postBuild;

      meta = perl.meta // {
        outputsToInstall = [ "out" ];
      }; # remove "man" from meta.outputsToInstall. pkgs.buildEnv produces no "man", it puts everything to "out"

      passthru = perl.passthru // {
        interpreter = "${env}/bin/perl";
        inherit perl;
      };
    };
in
env
