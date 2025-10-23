{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  installShellFiles,
  setuptools-scm,
  shtab,
  importlib-metadata,
  jaraco-classes,
  jaraco-context,
  jaraco-functools,
  jeepney,
  secretstorage,
  pyfakefs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "keyring";
  version = "25.6.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "keyring";
    tag = "v${version}";
    hash = "sha256-qu9HAlZMLlIVs8c9ClzWUljezhrt88gu1kouklMNxMY=";
  };

  build-system = [ setuptools-scm ];

  nativeBuildInputs = [
    installShellFiles
    shtab
  ];

  dependencies = [
    jaraco-classes
    jaraco-context
    jaraco-functools
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    jeepney
    secretstorage
  ]
  ++ lib.optionals (pythonOlder "3.12") [ importlib-metadata ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd keyring \
      --bash <($out/bin/keyring --print-completion bash) \
      --zsh <($out/bin/keyring --print-completion zsh)
  '';

  pythonImportsCheck = [
    "keyring"
    "keyring.backend"
  ];

  nativeCheckInputs = [
    pyfakefs
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/backends/test_macOS.py"
  ]
  # These tests fail when sandboxing is enabled because they are unable to get a password from keychain.
  ++ lib.optional stdenv.hostPlatform.isDarwin "tests/test_multiprocess.py";

  meta = with lib; {
    description = "Store and access your passwords safely";
    homepage = "https://github.com/jaraco/keyring";
    changelog = "https://github.com/jaraco/keyring/blob/${src.tag}/NEWS.rst";
    license = licenses.mit;
    mainProgram = "keyring";
    maintainers = with maintainers; [
      lovek323
      dotlambda
    ];
    platforms = platforms.unix;
  };
}
