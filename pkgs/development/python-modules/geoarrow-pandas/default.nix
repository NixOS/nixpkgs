{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pandas,
  pyarrow,
  geoarrow-pyarrow,
  geoarrow-types,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "geoarrow-pandas";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "geoarrow-python";
    owner = "geoarrow";
    tag = "geoarrow-types-${version}";
    hash = "sha256-ciElwh94ukFyFdOBuQWyOUVpn4jBM1RKfxiBCcM+nmE=";
  };

  sourceRoot = "${src.name}/geoarrow-pandas";

  build-system = [ setuptools-scm ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dependencies = [
    geoarrow-pyarrow
    geoarrow-types
    pandas
    pyarrow
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "geoarrow.pandas" ];

  meta = {
    description = "Python implementation of the GeoArrow specification";
    homepage = "https://github.com/geoarrow/geoarrow-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cpcloud
    ];
    teams = [ lib.teams.geospatial ];
    # its removal upstream is in question
    # https://github.com/geoarrow/geoarrow-python/issues/75
    # please unbreak it if the author decides to release a new version
    broken = true;
  };
}
