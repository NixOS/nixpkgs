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
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c920d8129752ee3f339c8cf3dfeba800a25730249d6ab43dc9b3c384312d1d32";
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
