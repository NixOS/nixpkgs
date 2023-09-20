{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, flask
, hatchling
, hatch-vcs
, isPy27
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "picobox";
  version = "3.0.0";

  format = "pyproject";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "ikalnytskyi";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-LQiSurL+eFRJ9iQheoo66o44BlfBtAatk8deuMFROcc=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    flask
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "picobox"
  ];

  meta = with lib; {
    description = "Opinionated dependency injection framework";
    homepage = "https://github.com/ikalnytskyi/picobox";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
  };
}
