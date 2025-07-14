{
  lib,
  buildPythonPackage,
  distro,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "ruyaml";
  version = "0.91.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = "ruyaml";
    tag = "v${version}";
    hash = "sha256-A37L/voBrn2aZ7xT8+bWdZJxbWRjnxbstQtSyUeN1sA=";
  };

  postPatch = ''
    # https://github.com/pycontribs/ruyaml/pull/107
    substituteInPlace pyproject.toml \
      --replace '"pip >= 19.3.1",' "" \
      --replace '"setuptools_scm_git_archive >= 1.1",' ""
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ distro ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  pythonImportsCheck = [ "ruyaml" ];

  disabledTests = [
    # Assertion error
    "test_issue_60"
    "test_issue_60_1"
    "test_issue_61"
  ];

  meta = with lib; {
    description = "YAML 1.2 loader/dumper package for Python";
    homepage = "https://ruyaml.readthedocs.io/";
    changelog = "https://github.com/pycontribs/ruyaml/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
