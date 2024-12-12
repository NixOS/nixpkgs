{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  autoreconfHook,
  nix,
  nasm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "isa-l";
  version = "2.31.0-unstable-2024-04-25";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "isa-l";
    rev = "dbaf284e112bea1b90983772a3164e794b923aaf";
    sha256 = "sha256-eM1K3uObb4eZq0nSfafltp5DuZIDwknUYj9CdLn14lY=";
  };

  nativeBuildInputs = [
    nasm
    autoreconfHook
  ];

  preConfigure = ''
    export AS=nasm
  '';

  passthru = {
    tests = {
      igzip =
        runCommand "test-isa-l-igzip"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
            ];
            sample =
              runCommand "nixpkgs-lib.nar"
                {
                  nativeBuildInputs = [ nix ];
                }
                ''
                  nix nar --extra-experimental-features nix-command pack ${../../../../lib} > "$out"
                '';
            meta = {
              description = "Cross validation of igzip provided by isa-l with gzip";
            };
          }
          ''
            HASH_ORIGINAL="$(cat "$sample" | sha256sum | cut -d" " -f1)"
            HASH_COMPRESSION_TEST="$(igzip -c "$sample" | gzip -d -c | sha256sum | cut -d" " -f1)"
            HASH_DECOMPRESSION_TEST="$(gzip -c "$sample" | igzip -d -c | sha256sum | cut -d" " -f1)"
            if [[ "$HASH_COMPRESSION_TEST" != "$HASH_ORIGINAL" ]] || [[ "$HASH_DECOMPRESSION_TEST" != "$HASH_ORIGINAL" ]]; then
              if [[ "HASH_COMPRESSION_TEST" != "$HASH_ORIGINAL" ]]; then
                echo "The igzip-compressed file does not decompress to the original file." 1>&2
              fi
              if [[ "HASH_DECOMPRESSION_TEST" != "$HASH_ORIGINAL" ]]; then
                echo "igzip does not decompress the gzip-compressed archive to the original file." 1>&2
              fi
              echo "SHA256 checksums:" 1>&2
              printf '  original file:\t%s\n' "$HASH_ORIGINAL" 1>&2
              printf '  compression test:\t%s\n' "$HASH_COMPRESSION_TEST" 1>&2
              printf '  decompression test:\t%s\n' "$HASH_DECOMPRESSION_TEST" 1>&2
              exit 1
            fi
            touch "$out"
          '';
    };
  };

  meta = {
    description = "Collection of optimised low-level functions targeting storage applications";
    mainProgram = "igzip";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/intel/isa-l";
    maintainers = with lib.maintainers; [ jbedo ];
    platforms = lib.platforms.all;
  };
})
