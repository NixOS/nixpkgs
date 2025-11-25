{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  gitUpdater,
  flit-core,
  pytest,
}:

buildPythonPackage rec {
  pname = "pytest-unmagic";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dimagi";
    repo = "pytest-unmagic";
    tag = "v${version}";
    hash = "sha256-XHeQuMCYHtrNF5+7e/eMzcvYukM+AobHCMRdzL+7KpU=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "unmagic" ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Pytest fixtures with conventional import semantics";
    homepage = "https://github.com/dimagi/pytest-unmagic";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
