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
  version = "0.5.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21097cbb37c9a0590e2cb444b55bd87302fc8f69640fa2d4f2d113e98e9558ff";
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
