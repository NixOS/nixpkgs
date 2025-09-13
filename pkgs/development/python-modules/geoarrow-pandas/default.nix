{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  pandas,
  pyarrow,
  geoarrow-pyarrow,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "geoarrow-pandas";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "geoarrow-python";
    owner = "geoarrow";
    tag = "geoarrow-pandas-${version}";
    hash = "sha256-Ni+GKTRhRDRHip1us3OZPuUhHQCNU7Nap865T/+CU8Y=";
  };

  sourceRoot = "${src.name}/geoarrow-pandas";

  build-system = [ setuptools-scm ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dependencies = [
    geoarrow-pyarrow
    pandas
    pyarrow
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "geoarrow.pandas" ];

  meta = with lib; {
    description = "Python implementation of the GeoArrow specification";
    homepage = "https://github.com/geoarrow/geoarrow-python";
    license = licenses.asl20;
    maintainers = with maintainers; [
      cpcloud
    ];
    teams = [ lib.teams.geospatial ];
  };
}
