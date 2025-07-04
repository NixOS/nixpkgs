{
  buildPythonPackage,
  lib,
  git,
  fetchFromGitHub,
  setuptools,
  git-annex,
  pyside6,
  pyqtdarktheme,
  datalad-next,
  outdated,
  datalad,
  pytestCheckHook,
  pytest-qt,
}:

buildPythonPackage {
  pname = "datalad-gooey";
  # many bug fixes on `master` but no new release
  version = "unstable-2024-02-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datalad";
    repo = "datalad-gooey";
    rev = "5bd6b9257ff1569439d2a77663271f5d665e61b6";
    hash = "sha256-8779SLcV4wwJ3124lteGzvimDxgijyxa818ZrumPMs4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyside6
    pyqtdarktheme
    datalad-next
    outdated
    datalad
  ];

  pythonRemoveDeps = [ "applescript" ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-qt
    git
    git-annex
  ];

  pythonImportsCheck = [ "datalad_gooey" ];

  meta = {
    description = "Graphical user interface (GUI) for DataLad";
    homepage = "https://github.com/datalad/datalad-gooey";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
    mainProgram = "datalad-gooey";
  };
}
