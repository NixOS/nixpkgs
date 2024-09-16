{
  lib,
  buildPythonPackage,
  distutils,
  fetchFromGitHub,
  passlib,
  pip,
  pytestCheckHook,
  pythonOlder,
  setuptools-git,
  setuptools,
  twine,
  watchdog,
  webtest,
  wheel,
}:

buildPythonPackage rec {
  pname = "pypiserver";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pypiserver";
    repo = "pypiserver";
    rev = "refs/tags/v${version}";
    hash = "sha256-Eh/3URt7pcJhoDDLRP8iHyjlPsE5E9M/0Hixqi5YNdg=";
  };

  build-system = [
    setuptools
    setuptools-git
    wheel
  ];

  dependencies = [
    distutils
    pip
  ];

  optional-dependencies = {
    passlib = [ passlib ];
    cache = [ watchdog ];
  };

  nativeCheckInputs = [
    pip
    pytestCheckHook
    setuptools
    twine
    webtest
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  __darwinAllowLocalNetworking = true;

  # Tests need these permissions in order to use the FSEvents API on macOS.
  sandboxProfile = ''
    (allow mach-lookup (global-name "com.apple.FSEvents"))
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # Fails to install the package
    "test_hash_algos"
    "test_pip_install_authed_succeeds"
    "test_pip_install_open_succeeds"
  ];

  disabledTestPaths = [
    # Test requires docker service running
    "docker/test_docker.py"
  ];

  pythonImportsCheck = [ "pypiserver" ];

  meta = with lib; {
    description = "Minimal PyPI server for use with pip/easy_install";
    homepage = "https://github.com/pypiserver/pypiserver";
    changelog = "https://github.com/pypiserver/pypiserver/releases/tag/v${version}";
    license = with licenses; [
      mit
      zlib
    ];
    maintainers = with maintainers; [ austinbutler ];
    mainProgram = "pypi-server";
  };
}
