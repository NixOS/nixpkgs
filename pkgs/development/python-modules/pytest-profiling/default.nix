{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gprof2dot,
  pypaInstallHook,
  pytest,
  pytest-virtualenv,
  pytestCheckHook,
  setuptoolsBuildHook,
  six,
}:

buildPythonPackage rec {
  pname = "pytest-profiling";
  version = "1.8.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "man-group";
    repo = "pytest-plugins";
    rev = "refs/tags/${version}";
    hash = "sha256-OYPdfMZrG4aTVnSAorVYxBgNNxIqHhO5yF8PUGhPBgA=";
  };

  sourceRoot = "${src.name}/pytest-profiling";

  # Python has some trouble finding `common_setup.py` in the root
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'sys.path.append(os.path.dirname(os.path.dirname(__file__)))' 'sys.path.append("${src}")'
  '';

  nativeBuildInputs = [
    pypaInstallHook
    setuptoolsBuildHook
  ];

  dependencies = [
    gprof2dot
    pytest
    six
  ];

  nativeCheckInputs = [
    pytest-virtualenv
    pytestCheckHook
  ];

  # ValueError: 'int' is not callable
  doCheck = false;

  disabledTests = [
    # Tries to use `python -m venv`
    "test_profile_chdir"
    "test_profile_generates_svg"
    "test_profile_long_name"
    "test_profile_profiles_tests"
  ];

  pythonImportsCheck = [ "pytest_profiling" ];

  meta = {
    description = "Profiling plugin for py.test";
    changelog = "https://github.com/man-group/pytest-plugins/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
