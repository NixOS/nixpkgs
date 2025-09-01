{
  lib,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  poetry-core,
  colorama,
  tabulate,
  unidecode,
  buildPythonPackage,
}:
buildPythonPackage rec {
  pname = "cli-ui";
  version = "0.19.0";
  pyproject = true;

  disabled = pythonOlder "3.8.1";

  src = fetchFromGitHub {
    owner = "your-tools";
    repo = "python-cli-ui";
    tag = "v${version}";
    hash = "sha256-BLc55LkVQwZ18V/fD/lBYw6jgchE8n0ijDTSr8/Jkdk=";
  };

  pythonRelaxDeps = [ "tabulate" ];

  build-system = [ poetry-core ];

  dependencies = [
    colorama
    tabulate
    unidecode
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cli_ui" ];

  meta = with lib; {
    description = "Build Nice User Interfaces In The Terminal";
    homepage = "https://github.com/your-tools/python-cli-ui";
    license = licenses.bsd3;
    maintainers = with maintainers; [ slashformotion ];
  };
}
