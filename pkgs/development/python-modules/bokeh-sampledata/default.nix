{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-git-versioning,

  # dependencies
  icalendar,
  pandas,
}:

buildPythonPackage rec {
  pname = "bokeh-sampledata";
  version = "2025.0";
  pyproject = true;

  src = fetchPypi {
    pname = "bokeh_sampledata";
    inherit version;
    hash = "sha256-a4dK9bh45w8WEzaVrAfhXeOGQvqfrf33I/fUIzOWevQ=";
  };

  build-system = [
    setuptools
    setuptools-git-versioning
  ];

  dependencies = [
    icalendar
    pandas
  ];

  pythonImportsCheck = [
    "bokeh_sampledata"
  ];

  meta = {
    description = "Sample datasets for Bokeh examples";
    homepage = "https://pypi.org/project/bokeh-sampledata";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
