{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "audioread";
  version = "3.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EhmVvSB+sf2j1Wa+uFHTU0J1klvDWk+22gyxHeD3JRo=";
  };

  # No tests, need to disable or py3k breaks
  doCheck = false;

  meta = {
    description = "Cross-platform audio decoding";
    homepage = "https://github.com/sampsyo/audioread";
    license = lib.licenses.mit;
  };
}
