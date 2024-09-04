{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  pythonOlder,
  rich,
  typer,
}:

buildPythonPackage rec {
  pname = "aiovlc";
  version = "0.4.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = "aiovlc";
    rev = "refs/tags/v${version}";
    hash = "sha256-kiF2BRqaQLNpd+EoKrI9/9m3E1DlyJqM3Ng0qA0TfyQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    rich
    typer
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiovlc" ];

  meta = with lib; {
    description = "Python module to control VLC";
    homepage = "https://github.com/MartinHjelmare/aiovlc";
    changelog = "https://github.com/MartinHjelmare/aiovlc/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
