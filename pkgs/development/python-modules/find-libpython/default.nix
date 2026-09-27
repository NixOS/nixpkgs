{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "find-libpython";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ktbarrett";
    repo = "find_libpython";
    tag = "v${version}";
    hash = "sha256-g2Gl+usa1mJMvvumynnoy/ckFTSrFA57o339t2j9lWQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "find_libpython" ];

  meta = {
    description = "Finds the libpython associated with your environment, wherever it may be hiding";
    changelog = "https://github.com/ktbarrett/find_libpython/releases/tag/${src.tag}";
    homepage = "https://github.com/ktbarrett/find_libpython";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jleightcap ];
    mainProgram = "find_libpython";
  };
}
