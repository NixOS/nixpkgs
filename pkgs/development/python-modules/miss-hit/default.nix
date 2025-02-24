{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  coverage,
  miss-hit-core,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "miss-hit";
  version = "0.9.44";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "florianschanda";
    repo = "miss_hit";
    tag = version;
    hash = "sha256-dJZIleDWmdarhmxoKvQxWvI/Tmx9pSCNlgFXj5NFIUc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    miss-hit-core
  ];

  configurePhase = ''
    runHook preConfigure

    cp setup_agpl.py setup.py

    runHook postConfigure
  '';

  nativeCheckInputs = [
    coverage
  ];

  checkPhase = ''
    runHook preCheck

    cd tests
    ${python.interpreter} ./run.py

    runHook postCheck
  '';

  pythonImportsCheck = [
    "miss_hit"
  ];

  meta = {
    description = "Static analysis and other utilities for programs written in the MATLAB/Simulink and Octave languages";
    homepage = "https://misshit.org/";
    changelog = "https://github.com/florianschanda/miss_hit/releases/tag/${version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      jacobkoziej
    ];
  };
}
