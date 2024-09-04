{
  lib,
  python3Packages,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  poetry-core,
  colorama,
  tabulate,
  unidecode,
}:
python3Packages.buildPythonPackage rec {
  pname = "cli-ui";
  version = "0.17.2";
  pyproject = true;

  disabled = pythonOlder "3.8.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L2flDPR052rRYMPmYLutmL+LjfuNhHdl86Jht+E8Bfo=";
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
