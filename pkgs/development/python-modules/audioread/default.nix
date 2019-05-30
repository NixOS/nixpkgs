{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "audioread";
  version = "2.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f488f9e6fa1ccb09289e3db194639bc6388168b27ef27b2c62380aa1d35a3abe";
  };

  # No tests, need to disable or py3k breaks
  doCheck = false;

  meta = {
    description = "Cross-platform audio decoding";
    homepage = "https://github.com/sampsyo/audioread";
    license = lib.licenses.mit;
  };
}