{
  lib,
  stdenv,
  buildPythonPackage,
  build,
  click,
  fetchFromGitHub,
  pep517,
  pip,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
  tomli,
  tomli-w,
  wheel,
}:

buildPythonPackage rec {
  pname = "pip-tools";
  version = "7.5.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "pip-tools";
    tag = "v${version}";
    hash = "sha256-o2qpaiy+oL3QzfVaGaaRa+2drCjzc6YwNsJlK8NBICY=";
  };

  patches = [ ./fix-setup-py-bad-syntax-detection.patch ];

  build-system = [ setuptools-scm ];

  dependencies = [
    build
    click
    pep517
    pip
    setuptools
    wheel
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
    tomli-w
  ];

  preCheck = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    # https://github.com/python/cpython/issues/74570#issuecomment-1093748531
    export no_proxy='*';
  '';

  disabledTests = [
    # Tests require network access
    "network"
    "test_bad_setup_file"
    "test_compile_build_targets_setuptools_no_wheel_dep"
    "test_compile_recursive_extras_build_targets"
    "test_direct_reference_with_extras"
    "test_error_in_pyproject_toml"
    "test_local_duplicate_subdependency_combined"
  ];

  pythonImportsCheck = [ "piptools" ];

  meta = with lib; {
    description = "Keeps your pinned dependencies fresh";
    homepage = "https://github.com/jazzband/pip-tools/";
    changelog = "https://github.com/jazzband/pip-tools/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
