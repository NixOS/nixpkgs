{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  setuptools,
  docutils,
  nicegui,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "nicegui-highcharts";
  version = "2.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zauberzeug";
    repo = "nicegui-highcharts";
    rev = "refs/tags/v${version}";
    hash = "sha256-r4X4faU7Nlq/FDbIYbTpvnC1w14XskpsNGtkEXtGrFo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools>=30.3.0,<50",' ""
  '';

  pythonRelaxDeps = [
    "docutils"
    "nicegui"
  ];

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [
    docutils
    nicegui
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "nicegui_highcharts" ];

  meta = {
    description = "NiceGUI with support for Highcharts";
    homepage = "https://github.com/zauberzeug/nicegui-highcharts";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
