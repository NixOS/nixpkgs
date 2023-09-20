{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      name = "test-expired.patch";
      url = "https://github.com/SAML-Toolkits/python3-saml/commit/bd65578e5a21494c89320094c61c1c77250bea33.diff";
      hash = "sha256-9Trew6R5JDjtc0NRGoklqMVDEI4IEqFOdK3ezyBU6gI=";
    })
    # skip tests with expired test data
    # upstream issue: https://github.com/SAML-Toolkits/python3-saml/issues/373
    ./skip-broken-tests.patch
  ];

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
