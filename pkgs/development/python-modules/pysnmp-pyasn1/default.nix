{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pysnmp-pyasn1";
  version = "1.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pysnmp";
    repo = "pyasn1";
    rev = "v${version}";
    hash = "sha256-W74aWMqGlat+aZfhbP1cTKRz7SomHdGwfK5yJwxgyqI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyasn1"
  ];

  meta = with lib; {
    description = "Python ASN.1 encoder and decoder";
    homepage = "https://github.com/pysnmp/pyasn1";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
