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
  version = "2024.2";
  pyproject = true;

  src = fetchPypi {
    pname = "bokeh_sampledata";
    inherit version;
    hash = "sha256-5j2qluedVj7IuE8gZy/+lPkFshRV+rjYPuM05G2jNiQ=";
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
