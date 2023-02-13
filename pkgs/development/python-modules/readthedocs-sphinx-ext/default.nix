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
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5e/82CWBYRGjd6t6iXuBkhUTj45eisyG+ZIYMo+VckA=";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ pytest mock sphinx ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Sphinx extension for Read the Docs overrides";
    homepage = "https://github.com/rtfd/readthedocs-sphinx-ext";
    license = licenses.mit;
  };
}
