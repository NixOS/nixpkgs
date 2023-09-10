{ lib
, buildPythonPackage
, fetchFromGitHub
, jsonconversion
, six
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "amazon-ion";
  version = "0.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # test vectors require git submodule
  src = fetchFromGitHub {
    owner = "amzn";
    repo = "ion-python";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-FLwzHcge+vLcRY4gOzrxS3kWlprCkRXX5KeGOoTJDSw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  propagatedBuildInputs = [
    jsonconversion
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # ValueError: Exceeds the limit (4300) for integer string conversion
    "test_roundtrips"
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
