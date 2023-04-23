{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, requests
, six
}:

buildPythonPackage rec {
  pname = "requests-file";
  version = "1.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B9dCCNM4nQHDirie9AOvDP7GOVfVOgCB2OynONAkfY4=";
  };

  propagatedBuildInputs = [
    requests
    six
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
