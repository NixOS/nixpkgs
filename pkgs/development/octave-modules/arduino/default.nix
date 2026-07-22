{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  instrument-control,
  arduino-core-unwrapped,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "arduino";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-arduino";
    tag = "release-${version}";
    sha256 = "sha256-gYoYXJwkuoI1S2SdOu6qpemlSjgAAx7N5LYwJq9ZrU8=";
  };

  requiredOctavePackages = [
    instrument-control
  ];

  propagatedBuildInputs = [
    arduino-core-unwrapped
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release-(.*)"
    ];
  };

  meta = {
    name = "Octave Arduino Toolkit";
    homepage = "https://gnu-octave.github.io/packages/arduino/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Basic Octave implementation of the matlab arduino extension, allowing communication to a programmed arduino board to control its hardware";
  };
}
