{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, six
, pytestCheckHook
, python-dateutil
}:

buildPythonPackage rec {
  version = "0.8.1";
  pname = "javaproperties";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = pname;
    rev = "v${version}";
    sha256 = "16rcdw5gd4a21v2xb1j166lc9z2dqcv68gqvk5mvpnm0x6nwadgp";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    python-dateutil
    pytestCheckHook
  ];

  disabledTests = [
    "time"
  ];

  disabledTestPaths = [
    "test/test_propclass.py"
  ];

  meta = with lib; {
    description = "Microsoft Azure API Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
