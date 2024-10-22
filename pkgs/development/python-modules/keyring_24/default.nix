{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  installShellFiles,
  setuptools,
  setuptools-scm,
  shtab,
  importlib-metadata,
  jaraco-classes,
  jaraco-context,
  jaraco-functools,
  jeepney,
  secretstorage,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "keyring_24";
  # nixpkgs-update: no auto update
  version = "24.3.1";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "keyring";
    hash = "sha256-wzJ7b/r8DovvvbWXys20ko/+XBIS92RfGG5tmVeomNs=";
  };

  nativeBuildInputs = [
    installShellFiles
    shtab
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies =
    [
      jaraco-classes
      jaraco-context
      jaraco-functools
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      jeepney
      secretstorage
    ]
    ++ lib.optionals (pythonOlder "3.12") [ importlib-metadata ];

  postInstall = ''
    installShellCompletion --cmd keyring \
      --bash <($out/bin/keyring --print-completion bash) \
      --zsh <($out/bin/keyring --print-completion zsh)
  '';

  pythonImportsCheck = [
    "keyring"
    "keyring.backend"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths =
    [ "tests/backends/test_macOS.py" ]
    # These tests fail when sandboxing is enabled because they are unable to get a password from keychain.
    ++ lib.optional stdenv.hostPlatform.isDarwin "tests/test_multiprocess.py";

  meta = with lib; {
    description = "Store and access your passwords safely";
    homepage = "https://github.com/jaraco/keyring";
    changelog = "https://github.com/jaraco/keyring/blob/v${version}/NEWS.rst";
    license = licenses.mit;
    mainProgram = "keyring";
    maintainers = with maintainers; [ jnsgruk ];
  };
}
