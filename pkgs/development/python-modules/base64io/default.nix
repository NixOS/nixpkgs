{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "base64io";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JPLQ/nZcNTOeGy0zqpX5E3sbdltZQWT60QFsFYJ6cHM=";
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://base64io-python.readthedocs.io/";
    changelog = "https://github.com/aws/base64io-python/blob/${version}/CHANGELOG.rst";
    description = "Python stream implementation for base64 encoding/decoding";
    license = licenses.asl20;
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
