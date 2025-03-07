{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  msal,
  portalocker,
  setuptools,
  stdenv,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "msal-extensions";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "AzureAD";
    repo = "microsoft-authentication-extensions-for-python";
    tag = version;
    hash = "sha256-javYE1XDW1yrMZ/BLqIu/pUXChlBZlACctbD2RfWuis=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "portalocker" ];

  dependencies = [
    msal
    portalocker
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests =
    [
      # `from gi.repository import Secret` fails to find libsecret
      "test_token_cache_roundtrip_with_persistence_builder"
      "test_libsecret_persistence"
      "test_nonexistent_libsecret_persistence"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      #  msal_extensions.osx.KeychainError
      "test_keychain_roundtrip"
      "test_keychain_persistence"
    ];

  pythonImportsCheck = [ "msal_extensions" ];

  meta = with lib; {
    description = "Microsoft Authentication Library Extensions (MSAL-Extensions) for Python";
    homepage = "https://github.com/AzureAD/microsoft-authentication-extensions-for-python";
    changelog = "https://github.com/AzureAD/microsoft-authentication-extensions-for-python/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
