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
    # skip tests with expired test data
    # upstream issue: https://github.com/SAML-Toolkits/python3-saml/issues/373
    (fetchpatch {
      name = "test-expired.patch";
      url = "https://github.com/SAML-Toolkits/python3-saml/commit/bd65578e5a21494c89320094c61c1c77250bea33.diff";
      hash = "sha256-9Trew6R5JDjtc0NRGoklqMVDEI4IEqFOdK3ezyBU6gI=";
    })
    (fetchpatch {
      name = "test-expired.patch";
      url = "https://github.com/SAML-Toolkits/python3-saml/commit/ea3a6d4ee6ea0c5cfb0f698d8c0ed25638150f47.patch";
      hash = "sha256-Q9+GM+mCEZK0QVp7ulH2hORVig2411OvkC4+o36DeXg=";
    })
    (fetchpatch {
      name = "test-expired.patch";
      url = "https://github.com/SAML-Toolkits/python3-saml/commit/feb0d1d954ee4d0ad1ad1d7d536bf9e83fa9431b.patch";
      hash = "sha256-NURGI4FUnFlWRZfkioU9IYmZ+Zk9FKfZchjdn7N9abU=";
    })
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
