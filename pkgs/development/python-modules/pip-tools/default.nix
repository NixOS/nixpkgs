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
, tomli
, tomli-w
, wheel
}:

buildPythonPackage rec {
  pname = "pip-tools";
  version = "7.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jpyZEn/gJMAltGoLLRXHvUfxjzMibPczDTVJNmP8HR0=";
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
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    tomli-w
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
