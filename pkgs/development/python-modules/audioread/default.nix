{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "audioread";
  version = "2.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0b9270c20833a75ce0d167fb2fdad52ddcd8e8f300be8afad3ac9715850bc50";
  };

  # No tests, need to disable or py3k breaks
  doCheck = false;

  meta = {
    description = "Cross-platform audio decoding";
    homepage = https://github.com/sampsyo/audioread;
    license = lib.licenses.mit;
  };
}