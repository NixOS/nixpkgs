{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
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
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "keyring";
  version = "25.2.1";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2q/9QtvaJd2vsa1f7EAk5bvP5CRZfKHKRSspmGHknxs=";
  };

  nativeBuildInputs = [
    installShellFiles
    setuptools-scm
    shtab
  ];

  propagatedBuildInputs =
    [
      jaraco-classes
      jaraco-context
      jaraco-functools
    ]
    ++ lib.optionals stdenv.isLinux [
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
    ++ lib.optional stdenv.isDarwin "tests/test_multiprocess.py";

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
