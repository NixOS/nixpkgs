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
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kiF77xTZE3e88nvffaNj5XSzseQYC2Xu9ufPpV8P0Lg=";
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
