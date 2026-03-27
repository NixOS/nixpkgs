{
  lib,
  fetchFromGitHub,
  pytestCheckHook,
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

  meta = {
    description = "Build Nice User Interfaces In The Terminal";
    homepage = "https://github.com/your-tools/python-cli-ui";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ slashformotion ];
  };
}
