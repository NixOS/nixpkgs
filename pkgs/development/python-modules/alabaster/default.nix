{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pygments
}:

buildPythonPackage rec {
  pname = "alabaster";
  version = "0.7.16";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dai5nCil2tUN1/jM3UR6Eh3bOJLanlPRylzKMQbVjWU=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [ pygments ];

  # No tests included
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/bitprophet/alabaster";
    description = "A Sphinx theme";
    license = licenses.bsd3;
  };
}
