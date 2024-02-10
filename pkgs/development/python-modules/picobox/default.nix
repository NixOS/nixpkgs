{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, hatchling
, hatch-vcs
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "picobox";
  version = "4.0.0";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ikalnytskyi";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-JtrwUVo3b4G34OUShX4eJS2IVubl4vBmEtB/Jhk4eJI=";
  };

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
