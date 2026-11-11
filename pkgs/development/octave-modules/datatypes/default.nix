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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "pr0m1th3as";
    repo = "datatypes";
    tag = "release-${version}";
    hash = "sha256-TqGn8fOS/n3/MyusX6N7zU3R9GkPocf3IJs7yzCjFok=";
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
