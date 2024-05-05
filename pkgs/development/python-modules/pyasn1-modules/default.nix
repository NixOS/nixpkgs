{ lib
, buildPythonPackage
, fetchFromGitHub
, pyasn1
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyasn1-modules";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyasn1";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-UJycVfj08+3zjHPji5Qlh3yqeS30dEwu1pyrN1yo1Vc=";
  };

  propagatedBuildInputs = [
    pyasn1
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyasn1_modules"
  ];

  meta = with lib; {
    description = "A collection of ASN.1-based protocols modules";
    homepage = "https://github.com/pyasn1/pyasn1-modules";
    changelog = "https://github.com/pyasn1/pyasn1-modules/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
