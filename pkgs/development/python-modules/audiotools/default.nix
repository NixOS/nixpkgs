{ lib
, buildPythonPackage
, fetchFromGitHub
, stdenv
, AudioToolbox
, AudioUnit
, CoreServices
}:

buildPythonPackage rec {
  pname = "audiotools";
  version = "3.1.1";

  buildInputs = lib.optionals stdenv.isDarwin [
    AudioToolbox
    AudioUnit
    CoreServices
  ];

  src = fetchFromGitHub {
    owner = "tuffy";
    repo = "python-audio-tools";
    rev = "v${version}";
    sha256 = "sha256-y+EiK9BktyTWowOiJvOb2YjtbPa7R62Wb5zinkyt1OM=";
  };

  meta = with lib; {
    description = "Utilities and Python modules for handling audio";
    homepage = "http://audiotools.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
