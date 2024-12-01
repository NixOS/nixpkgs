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
  build,
  importlib-resources,
}:

buildPythonPackage rec {
  pname = "pypiserver";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pypiserver";
    repo = "pypiserver";
    rev = "refs/tags/v${version}";
    hash = "sha256-5GJthS3kWOyWvYW+mYnIcNKD3fgSVexABZ+DpVh7qkE=";
  };

  build-system = [
    setuptools
    setuptools-git
    wheel
  ];

  dependencies = [
    distutils
    pip
  ] ++ lib.optionals (pythonOlder "3.12") [ importlib-resources ];

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
    build
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
