{ lib
, buildPythonPackage
, fetchPypi
, pyhumps
, pytest
, python
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "complycube";
  version = "1.1.4";
  format = "wheel";

  src = fetchPypi rec {
    inherit version format;
    pname = "complycube";
    #extension = "whl";
    dist = python;
    python = "py3";
    hash = "sha256-fpt82BfLLkma2udqRU+sUiQL85gd++RrbTKpmZVz6SE=";
  };

  nativeCheckInputs = [ pytest ];

  propagatedBuildInputs = [
    pyhumps
    requests
    setuptools
  ];

  checkPhase = ''
    py.test complycube/tests
  '';

  # Test failing due to upstream issue (https://bitbucket.org/amentajo/lib3to2/issues/50/testsuite-fails-with-new-python-35)
  doCheck = false;

  meta = {
    homepage = "https://complycube.com";
    description = "Official Python client for the ComplyCube API";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ der_dennisop ];
  };
}
