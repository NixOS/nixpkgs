{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  freezegun,
  isodate,
  lxml,
  pytestCheckHook,
  pythonOlder,
  poetry-core,
  xmlsec,
}:

buildPythonPackage rec {
  pname = "python3-saml";
  version = "1.16.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "onelogin";
    repo = "python3-saml";
    rev = "refs/tags/v${version}";
    hash = "sha256-KyDGmqhg/c29FaXPKK8rWKSBP6BOCpKKpOujCavXUcc=";
  };

  patches = [
    # Fix build system, https://github.com/SAML-Toolkits/python3-saml/pull/341
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/SAML-Toolkits/python3-saml/commit/231a7e19543138fdd7424c01435dfe3f82bbe9ce.patch";
      hash = "sha256-MvX1LXhf3LJUy3O7L0/ySyVY4KDGc/GKJud4pOkwVIk=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    isodate
    lxml
    xmlsec
  ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "onelogin.saml2" ];

  disabledTests = [
    # Tests require network acces or additions files
    "OneLogin_Saml2_Metadata_Test"
    "OneLogin_Saml2_Response_Test"
    "OneLogin_Saml2_Utils_Test"
    "OneLogin_Saml2_Settings_Test"
    "OneLogin_Saml2_Auth_Test"
    "OneLogin_Saml2_Authn_Request_Test"
    "OneLogin_Saml2_IdPMetadataParser_Test"
    "OneLogin_Saml2_Logout_Request_Test"
  ];

  meta = with lib; {
    description = "OneLogin's SAML Python Toolkit";
    homepage = "https://github.com/onelogin/python3-saml";
    changelog = "https://github.com/SAML-Toolkits/python3-saml/blob/v${version}/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
