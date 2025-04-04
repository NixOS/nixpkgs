{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  coverage,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "miss-hit-core";
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

  configurePhase = ''
    runHook preConfigure

    cp setup_gpl.py setup.py
    mkdir -p miss_hit_core/resources/assets
    cp docs/style.css miss_hit_core/resources
    cp docs/assets/* miss_hit_core/resources/assets

    runHook postConfigure
  '';

  nativeCheckInputs = [
    coverage
  ];

  checkPhase = ''
    runHook preCheck

    cd tests
    ${python.interpreter} ./run.py --suite=style
    ${python.interpreter} ./run.py --suite=metrics

    runHook postCheck
  '';

  pythonImportsCheck = [
    "miss_hit_core"
  ];

  meta = {
    description = "Code formatting and code metrics for programs written in the MATLAB/Simulink and Octave languages";
    homepage = "https://misshit.org/";
    changelog = "https://github.com/florianschanda/miss_hit/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      jacobkoziej
    ];
  };
}
