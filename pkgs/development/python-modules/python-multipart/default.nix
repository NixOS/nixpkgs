{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, pytestCheckHook
, mock
, pyyaml
, six
}:

buildPythonPackage rec {
  pname = "python-multipart";
  version = "0.0.7";
  format = "pyproject";

  src = fetchPypi {
    pname = "python_multipart";
    inherit version;
    hash = "sha256-KIpsObBllsG5iLtnlMb7yA5sNp415QYmN98la+4Mmvk=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    six
  ];

  pythonImportsCheck = [
    "multipart"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    pyyaml
  ];

  meta = with lib; {
    description = "A streaming multipart parser for Python";
    homepage = "https://github.com/andrew-d/python-multipart";
    license = licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}
