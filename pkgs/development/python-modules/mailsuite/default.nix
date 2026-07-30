{
  lib,
  azure-identity,
  authres,
  buildPythonPackage,
  cryptography,
  dkimpy,
  dnspython,
  expiringdict,
  fetchFromGitHub,
  google-api-python-client,
  google-auth,
  google-auth-oauthlib,
  hatchling,
  html2text,
  imapclient,
  mail-parser,
  msgraph-sdk,
  publicsuffix2,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mailsuite";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seanthegeek";
    repo = "mailsuite";
    tag = finalAttrs.version;
    hash = "sha256-qQ+AaelLQED0mWCAItx/3d7o9QVUnhUVxvdCfnNRqzQ=";
  };

  pythonRelaxDeps = [ "mail-parser" ];

  build-system = [ hatchling ];

  dependencies = [
    authres
    cryptography
    dkimpy
    dnspython
    expiringdict
    html2text
    mail-parser
    imapclient
    publicsuffix2
  ];

  optional-dependencies = {
    all = lib.concatAttrValues (lib.removeAttrs finalAttrs.passthru.optional-dependencies [ "all" ]);
    gmail = [
      google-api-python-client
      google-auth
      google-auth-oauthlib
    ];
    msgraph = [
      azure-identity
      msgraph-sdk
    ];
  };

  pythonImportsCheck = [ "mailsuite" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python package to simplify receiving, parsing, and sending email";
    homepage = "https://seanthegeek.github.io/mailsuite/";
    changelog = "https://github.com/seanthegeek/mailsuite/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ talyz ];
  };
})
