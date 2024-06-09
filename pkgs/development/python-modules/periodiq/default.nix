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
}:

buildPythonPackage rec {
  pname = "periodiq";
  version = "0.12.1";
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchFromGitLab {
    owner = "bersace";
    repo = "periodiq";
    rev = "v${version}";
    hash = "sha256-Ar0n+Wi1OUtRdhVxrU7Nz4je8ylaHgPZbXE0a30hzU0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pendulum = "^2.0"' 'pendulum = "*"' \
      --replace 'poetry>=0.12' 'poetry-core' \
      --replace 'poetry.masonry.api' 'poetry.core.masonry.api'
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
  ];

  pytestFlagsArray = [ "tests/unit" ];

  pythonImportsCheck = [ "periodiq" ];

  meta = with lib; {
    description = "Simple Scheduler for Dramatiq Task Queue";
    mainProgram = "periodiq";
    homepage = "https://pypi.org/project/periodiq/";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ traxys ];
  };
}
