{ lib
, stdenv
, buildPythonPackage
, build
, click
, fetchPypi
, pep517
, pip
, pytest-xdist
, pytestCheckHook
, pythonOlder
, setuptools
, setuptools-scm
<<<<<<< HEAD
, tomli
, tomli-w
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, wheel
}:

buildPythonPackage rec {
  pname = "pip-tools";
<<<<<<< HEAD
  version = "7.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jpyZEn/gJMAltGoLLRXHvUfxjzMibPczDTVJNmP8HR0=";
=======
  version = "6.13.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YdRr0uuAFu1Kkk4Zbm5bCiaM07q9eeWTBIcg2yNSK7E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [ ./fix-setup-py-bad-syntax-detection.patch ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    build
    click
    pep517
    pip
    setuptools
    wheel
<<<<<<< HEAD
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    tomli-w
=======
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  preCheck = lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    # https://github.com/python/cpython/issues/74570#issuecomment-1093748531
    export no_proxy='*';
  '';

  disabledTests = [
    # Tests require network access
    "network"
    "test_direct_reference_with_extras"
    "test_local_duplicate_subdependency_combined"
    "test_bad_setup_file"
    # Assertion error
    "test_compile_recursive_extras"
  ];

  pythonImportsCheck = [
    "piptools"
  ];

  meta = with lib; {
    description = "Keeps your pinned dependencies fresh";
    homepage = "https://github.com/jazzband/pip-tools/";
    changelog = "https://github.com/jazzband/pip-tools/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
