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
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zauberzeug";
    repo = "nicegui-highcharts";
    tag = "v${version}";
    hash = "sha256-9COui3gqLZqJSeZyzazxQcOc2oM9Li+dLBoy5VcEKBw=";
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
