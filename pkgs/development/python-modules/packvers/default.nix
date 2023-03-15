{ lib
, buildPythonPackage
, fetchFromGitHub
, pretend
, pyparsing
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "packvers";
  version = "21.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-nCSYL0g7mXi9pGFt24pOXbmmYsaRuB+rRZrygf8DTLE=";
  };

  propagatedBuildInputs = [
    pyparsing
  ];

  nativeCheckInputs = [
    pretend
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "packvers"
  ];

  meta = with lib; {
    description = "Module for version handling of modules";
    homepage = "https://github.com/nexB/dparse2";
    changelog = "https://github.com/nexB/packvers/blob/${version}/CHANGELOG.rst";
    license = with licenses; [ asl20 /* and */ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
