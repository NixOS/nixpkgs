{
  lib,
  beautifultable,
  buildPythonPackage,
  click-default-group,
  click,
  fetchFromGitHub,
  humanize,
  keyring,
  requests,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mwdblib";
  version = "4.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "mwdblib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K6izUFwzeVs7q0LCDz/pmb4Ghfm6hy/wDSpcYbg5wp0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifultable
    click
    click-default-group
    humanize
    keyring
    requests
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "mwdblib" ];

  meta = {
    description = "Python client library for the mwdb service";
    homepage = "https://github.com/CERT-Polska/mwdblib";
    changelog = "https://github.com/CERT-Polska/mwdblib/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mwdb";
  };
})
