{ lib
, buildPythonPackage
, fetchurl
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

  src = fetchurl {
    url = "https://github.com/tuffy/python-audio-tools/archive/v${version}.tar.gz";
    sha256 = "0ymlxvqkqhzk4q088qwir3dq0zgwqlrrdfnq7f0iq97g05qshm2c";
  };

  meta = {
    description = "Utilities and Python modules for handling audio";
    homepage = "http://audiotools.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
  };
}