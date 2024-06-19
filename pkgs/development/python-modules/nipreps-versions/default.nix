{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  flit-scm,
  packaging,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "nipreps-versions";
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nipreps";
    repo = "version-schemes";
    rev = "refs/tags/${version}";
    hash = "sha256-B2wtLurzgk59kTooH51a2dewK7aEyA0dAm64Wp+tqhM=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    flit-scm
    setuptools-scm
  ];

  propagatedBuildInputs = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "nipreps_versions" ];

  meta = with lib; {
    description = "Setuptools_scm plugin for nipreps version schemes";
    homepage = "https://github.com/nipreps/version-schemes";
    changelog = "https://github.com/nipreps/version-schemes/blob/${src.rev}/CHANGES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
