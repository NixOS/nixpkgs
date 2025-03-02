{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
  boost,
  numpy,
  scipy,
  simpleitk,
}:

buildPythonPackage rec {
  pname = "medpy";
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "loli";
    repo = "medpy";
    tag = version;
    hash = "sha256-M46d8qiR3+ioiuRhzIaU5bV1dnfDm819pjn78RYlcG0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    boost
    numpy
    scipy
    simpleitk
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  preCheck = ''
    rm -r medpy/  # prevent importing from build directory at test time
    rm -r tests/graphcut_  # SIGILL at test time
  '';

  pythonImportsCheck = [
    "medpy"
    "medpy.core"
    "medpy.features"
    "medpy.filter"
    "medpy.graphcut"
    "medpy.io"
    "medpy.metric"
    "medpy.utilities"
  ];

  meta = with lib; {
    description = "Medical image processing library";
    homepage = "https://loli.github.io/medpy";
    changelog = "https://github.com/loli/medpy/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
