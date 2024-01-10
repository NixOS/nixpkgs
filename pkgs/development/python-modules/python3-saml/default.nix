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
  version = "1.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "onelogin";
    repo = "python3-saml";
    rev = "refs/tags/v${version}";
    hash = "sha256-KyDGmqhg/c29FaXPKK8rWKSBP6BOCpKKpOujCavXUcc=";
  };

  propagatedBuildInputs = [
    isodate
    lxml
    xmlsec
  ];

  nativeCheckInputs = [
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
