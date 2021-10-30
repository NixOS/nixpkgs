{ lib
, buildPythonPackage
, fetchFromGitHub
, stdenv
, darwin
}:

buildPythonPackage rec {
  pname = "audiotools";
  version = "3.1.1";

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AudioToolbox
    AudioUnit
    CoreServices
  ]);

  src = fetchFromGitHub {
    owner = "tuffy";
    repo = "python-audio-tools";
    rev = "v3.1.1";
    sha256 = "sha256-y+EiK9BktyTWowOiJvOb2YjtbPa7R62Wb5zinkyt1OM=";
  };

  meta = {
    description = "Utilities and Python modules for handling audio";
    homepage = "http://audiotools.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
  };
}
