{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitLab,
  poetry-core,
  dramatiq,
  pendulum,
  setuptools,
  pytest-mock,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "periodiq";
  version = "0.13.0";
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchFromGitLab {
    owner = "bersace";
    repo = "periodiq";
    tag = "v${version}";
    hash = "sha256-Pyh/T3/HGPYyaXjyM0wkQ1V7p5ibqxE1Q62QwCIJ8To=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'poetry>=0.12' 'poetry-core' \
      --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    dramatiq
    pendulum
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  enabledTestPaths = [ "tests/unit" ];

  pythonImportsCheck = [ "periodiq" ];

  meta = {
    description = "Simple Scheduler for Dramatiq Task Queue";
    mainProgram = "periodiq";
    homepage = "https://pypi.org/project/periodiq/";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ traxys ];
  };
}
