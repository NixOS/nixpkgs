{
  lib,
  buildPythonPackage,
  cryptography,
  dnspython,
  fetchFromGitHub,
  nix-update-script,
  pyspnego,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "dpapi-ng";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jborean93";
    repo = "dpapi-ng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1GeayLsY9qGwlfEbkLbyi524MAKEmb/F1fzQ0jzrzF8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    dnspython
    pyspnego
  ];

  optional-dependencies = {
    kerberos = [ pyspnego ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dpapi_ng" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python DPAPI NG Decryptor for non-Windows Platforms";
    homepage = "https://github.com/jborean93/dpapi-ng";
    changelog = "https://github.com/jborean93/dpapi-ng/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
