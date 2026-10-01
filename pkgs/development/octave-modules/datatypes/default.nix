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
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "pr0m1th3as";
    repo = "datatypes";
    tag = "release-${version}";
    sha256 = "sha256-pjGJkcZg3m3UzoAexw4yw7ztZR/shT/W2Q1zfj+le0E=";
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
