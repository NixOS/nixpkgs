{ lib
, buildPythonPackage
, fetchPypi
, jsonconversion
, six
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "amazon-ion";
  version = "0.9.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "amazon.ion";
    inherit version;
    hash = "sha256-Moq1e7LmI0L7DHg6UNYvseEDbqdL23aCwL38wDm3yCA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    jsonconversion
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "amazon.ion"
  ];

  meta = with lib; {
    description = "Python implementation of Amazon Ion";
    homepage = "https://github.com/amzn/ion-python";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
  };
}
