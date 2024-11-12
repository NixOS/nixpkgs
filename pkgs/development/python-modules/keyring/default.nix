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
  version = "25.4.1";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "keyring";
    rev = "refs/tags/v${version}";
    hash = "sha256-5MK7f6/e8ZJ7azm5WX8T2+/6R3P3Y8XaN7jze2MgiJA=";
  };

  build-system = [ setuptools-scm ];

  nativeBuildInputs = [
    installShellFiles
    shtab
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

  nativeCheckInputs = [
    pyfakefs
    pytestCheckHook
  ];

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
    maintainers = with maintainers; [
      lovek323
      dotlambda
    ];
    platforms = platforms.unix;
  };
}
