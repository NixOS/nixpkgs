<<<<<<< HEAD
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
=======
{ buildPythonPackage
, fetchFromGitHub
, lib
, passlib
, pytestCheckHook
, setuptools
, setuptools-git
, twine
, webtest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pypiserver";
<<<<<<< HEAD
  version = "1.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "1.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
<<<<<<< HEAD
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
=======
    rev = "v${version}";
    hash = "sha256-1tV3pVEC5sIjT0tjbujU7l41Jx7PQ1dCn4B1r94C9xE=";
  };

  nativeBuildInputs = [ setuptools-git ];

  propagatedBuildInputs = [ setuptools ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
<<<<<<< HEAD
    pip
    pytestCheckHook
    setuptools
    twine
    webtest
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTests = [
    # Fails to install the package
=======
    passlib
    pytestCheckHook
    twine
    webtest
  ];

  disabledTests = [
    # fails to install the package
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "test_hash_algos"
    "test_pip_install_authed_succeeds"
    "test_pip_install_open_succeeds"
  ];

  disabledTestPaths = [
<<<<<<< HEAD
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
=======
    # requires docker service running
    "docker/test_docker.py"
  ];

  pythonImportsCheck = [ "pypiserver" ];

  meta = with lib; {
    homepage = "https://github.com/pypiserver/pypiserver";
    description = "Minimal PyPI server for use with pip/easy_install";
    license = with licenses; [ mit zlib ];
    maintainers = with maintainers; [ austinbutler SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
