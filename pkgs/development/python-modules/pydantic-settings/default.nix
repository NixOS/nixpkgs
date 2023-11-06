{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pydantic
, python-dotenv
, pytestCheckHook
, pytest-examples
, pytest-mock
}:

buildPythonPackage rec {
  pname = "pydantic-settings";
  version = "2.0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-settings";
    rev = "v${version}";
    hash = "sha256-3V6daCibvVr8RKo2o+vHC++QgIYKAOyRg11ATrCzM5Y=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pydantic
    python-dotenv
  ];

  pythonImportsCheck = [ "pydantic_settings" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-examples
    pytest-mock
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Settings management using pydantic";
    homepage = "https://github.com/pydantic/pydantic-settings";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
