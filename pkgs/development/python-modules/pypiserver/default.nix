{ lib
, buildPythonPackage
, fetchFromGitHub
, passlib
, pip
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-git
, twine
, watchdog
, webtest
, wheel
}:

buildPythonPackage rec {
  pname = "pypiserver";
  version = "1.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-jub+iVL/YeGaG9Vzqyyfc4qFi0cR+7xrzuXNHL5W4p4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-git
    wheel
  ];

  propagatedBuildInputs = [
    pip
  ];

  passthru.optional-dependencies = {
    passlib = [
      passlib
    ];
    cache = [
      watchdog
    ];
  };

  __darwinAllowLocalNetworking = true;

  # Tests need these permissions in order to use the FSEvents API on macOS.
  sandboxProfile = ''
    (allow mach-lookup (global-name "com.apple.FSEvents"))
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    pip
    pytestCheckHook
    setuptools
    twine
    webtest
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

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

  pythonImportsCheck = [
    "pypiserver"
  ];

  meta = with lib; {
    description = "Minimal PyPI server for use with pip/easy_install";
    homepage = "https://github.com/pypiserver/pypiserver";
    changelog = "https://github.com/pypiserver/pypiserver/releases/tag/v${version}";
    license = with licenses; [ mit zlib ];
    maintainers = with maintainers; [ austinbutler ];
  };
}
