{
  lib,
  python3,
  runCommand,
  git,
  nix,
  nix-prefetch-git,
}:

runCommand "update-python-libraries"
  {
    buildInputs = [
      (python3.withPackages (
        ps: with ps; [
          packaging
          requests
          toolz
        ]
      ))
    ];
  }
  ''
    cp ${./update-python-libraries.py} $out
    patchShebangs $out
    substituteInPlace $out \
      --replace-fail 'NIX = "nix"' 'NIX = "${lib.getExe nix}"' \
      --replace-fail 'NIX_PREFETCH_URL = "nix-prefetch-url"' 'NIX_PREFETCH_URL = "${lib.getExe' nix "nix-prefetch-url"}"' \
      --replace-fail 'NIX_PREFETCH_GIT = "nix-prefetch-git"' 'NIX_PREFETCH_GIT = "${lib.getExe nix-prefetch-git}"' \
      --replace-fail 'GIT = "git"' 'GIT = "${lib.getExe git}"'
  ''
