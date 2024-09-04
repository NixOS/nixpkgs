{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  stdenv,
  AudioToolbox,
  AudioUnit,
  CoreServices,
}:

buildPythonPackage rec {
  pname = "audiotools";
  version = "3.1.1";
  pyproject = true;

  build-system = [ setuptools ];

  buildInputs = lib.optionals stdenv.isDarwin [
    AudioToolbox
    AudioUnit
    CoreServices
  ];

  src = fetchFromGitHub {
    owner = "tuffy";
    repo = "python-audio-tools";
    rev = "v${version}";
    hash = "sha256-y+EiK9BktyTWowOiJvOb2YjtbPa7R62Wb5zinkyt1OM=";
  };

  meta = with lib; {
    description = "Utilities and Python modules for handling audio";
    homepage = "https://audiotools.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
