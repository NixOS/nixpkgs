{ lib
, fetchPypi
, buildPythonPackage
, setuptools
, setuptools-scm
, pytestCheckHook
, requests
}:

buildPythonPackage rec {
  pname = "requests-file";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IMWTFinFWP2lZsrMEM/izVAkM+Yo9WjDTIDZagzJWXI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "requests_file"
  ];

  meta = with lib; {
    description = "Transport adapter for fetching file:// URLs with the requests python library";
    homepage = "https://github.com/dashea/requests-file";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
