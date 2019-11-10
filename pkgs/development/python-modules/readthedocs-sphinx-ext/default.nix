{ lib
, buildPythonPackage
, fetchPypi
, requests
, pytest
, mock
, sphinx
}:

buildPythonPackage rec {
  pname = "readthedocs-sphinx-ext";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc94753be6b2db997e3291046b39e49d578f6441fd75159db22a51a29d2cf1fc";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest mock sphinx ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Sphinx extension for Read the Docs overrides";
    homepage = https://github.com/rtfd/readthedocs-sphinx-ext;
    license = licenses.mit;
  };
}
