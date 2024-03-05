{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pytest-localserver
, numpy
, pillow
, pydicom
, requests
, retrying
}:

buildPythonPackage rec {
  pname = "dicomweb-client";
  version = "0.59.1";
  disabled = pythonOlder "3.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ImagingDataCommons";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-h9gFCBmutTGNJ3wP2AGPfiUtA49yywUlNKiSh/x9kFE=";
  };

  propagatedBuildInputs = [
    numpy
    pillow
    pydicom
    requests
    retrying
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-localserver
  ];

  pythonImportsCheck = [
    "dicomweb_client"
  ];

  meta = with lib; {
    description = "Python client for DICOMweb RESTful services";
    homepage = "https://dicomweb-client.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "dicomweb_client";
  };
}
