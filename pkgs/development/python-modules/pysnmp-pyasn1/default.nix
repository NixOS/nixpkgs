{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pysnmp-pyasn1";
  version = "1.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pysnmp";
    repo = "pyasn1";
    rev = "v${version}";
    hash = "sha256-R4reMwVcJBTfTEHUk6sSUugsEPuKIziH1WbjMakP/dA=";
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
