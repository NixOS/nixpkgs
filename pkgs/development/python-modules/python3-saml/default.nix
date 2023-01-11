{ lib
, buildPythonPackage
, fetchFromGitHub
, freezegun
, isodate
, lxml
, pythonOlder
, xmlsec
}:

buildPythonPackage rec {
  pname = "python3-saml";
  version = "1.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "onelogin";
    repo = "python3-saml";
    rev = "refs/tags/v${version}";
    hash = "sha256-xPPR2z3h8RpoAROpKpu9ZoDxGq5Stm9wQVt4Stj/6fg=";
  };

  propagatedBuildInputs = [
    isodate
    lxml
    xmlsec
  ];

  checkInputs = [
    freezegun
  ];

  pythonImportsCheck = [
    "onelogin.saml2"
  ];

  meta = with lib; {
    description = "OneLogin's SAML Python Toolkit";
    homepage = "https://github.com/onelogin/python3-saml";
    changelog = "https://github.com/SAML-Toolkits/python3-saml/blob/v${version}/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
