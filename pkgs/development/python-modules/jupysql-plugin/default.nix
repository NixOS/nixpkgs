{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
  hatch-jupyter-builder,
  hatch-nodejs-version,
  jupyterlab,
  ploomber-core,
}:

buildPythonPackage rec {
  pname = "jupysql-plugin";
  version = "0.4.4";

  pyproject = true;
  disabled = pythonOlder "3.6";

  # using pypi archive which includes pre-built assets
  src = fetchPypi {
    pname = "jupysql_plugin";
    inherit version;
    hash = "sha256-kuaKknbc00nLGwCUsULgUFT52yoptUH2mnUyGYbYYKk=";
  };

  build-system = [
    hatchling
    hatch-jupyter-builder
    hatch-nodejs-version
    jupyterlab
  ];

  dependencies = [ ploomber-core ];

  # testing requires a circular dependency over jupysql
  doCheck = false;

  pythonImportsCheck = [ "jupysql_plugin" ];

  meta = with lib; {
    description = "Better SQL in Jupyter";
    homepage = "https://github.com/ploomber/jupysql-plugin";
    changelog = "https://github.com/ploomber/jupysql-plugin/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pacien ];
  };
}
