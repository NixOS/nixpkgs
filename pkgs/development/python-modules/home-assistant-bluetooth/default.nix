{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, bleak
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "home-assistant-bluetooth";
  version = "1.5.1";
  format = "pyproject";
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-//e+Kb85TBAC9/mHz/T/Dm/pNjbj0488/L/NeS1RMqY=";
  };

  postPatch = ''
    # drop pytest parametrization (coverage, etc.)
    sed -i '/addopts/d' pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bleak
  ];

  pythonImportsCheck = [
    "home_assistant_bluetooth"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Basic bluetooth models used by Home Assistant";
    changelog = "https://github.com/home-assistant-libs/home-assistant-bluetooth/blob/main/CHANGELOG.md";
    homepage = "https://github.com/home-assistant-libs/home-assistant-bluetooth";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
