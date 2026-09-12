{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  zip,
  unzip,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "datatypes";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "pr0m1th3as";
    repo = "datatypes";
    tag = "release-${version}";
    sha256 = "sha256-D1iWQmn7/v4QcCkFP6Th+aHmGh3dUg1Obe7qC7CYQ7w=";
  };

  nativeOctavePkgTestInputs = [
    zip
    unzip
    writableTmpDirAsHomeHook
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=release-(.*)" ]; };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/datatypes/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Extra data types for GNU Octave";
  };
}
