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
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "pr0m1th3as";
    repo = "datatypes";
    tag = "release-${version}";
    sha256 = "sha256-Odjx44GYvQOZhPFWQ0ueKpDkXaWeN2mufpLARBhZqic=";
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
