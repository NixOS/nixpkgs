{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-nodejs-version,
  ipywidgets,
  jupyterlab,
}:

buildPythonPackage rec {
  pname = "ipylab";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xPB0Sx+W1sRgW5hqpZ68zWRFG/cclIOgGat6UsVlYXA=";
  };

  build-system = [
    hatchling
    hatch-nodejs-version
    jupyterlab
  ];

  env.HATCH_BUILD_NO_HOOKS = true;

  dependencies = [
    ipywidgets
  ];

  pythonImportsCheck = [ "ipylab" ];

  # There are no tests
  doCheck = false;

  meta = {
    description = "Control JupyterLab from Python notebooks.";
    homepage = "https://github.com/jtpio/ipylab";
    changelog = "https://github.com/jtpio/ipylab/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ flokli ];
    badPlatforms = [
      # Unclear why it breaks on darwin only
      # ModuleNotFoundError: No module named 'ipylab._version'
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
