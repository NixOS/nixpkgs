{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  icalendar,
  pandas,
}:

buildPythonPackage rec {
  pname = "bokeh-sampledata";
  version = "2025.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bokeh";
    repo = "bokeh_sampledata";
    tag = version;
    hash = "sha256-gAiiNm9t+4z0aFO6pr8FfYGF04pO7u6Wjsbou+I2blk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    setuptools
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
