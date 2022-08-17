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
  version = "0.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # test vectors require git submodule
  src = fetchFromGitHub {
    owner = "amzn";
    repo = "ion-python";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-BLlKxm63KsmMFajS4uJne/LPNXboOfy4uVm8HqO9Wfo=";
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
