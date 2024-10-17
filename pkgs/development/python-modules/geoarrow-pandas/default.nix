{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  geoarrow-pyarrow,
  pandas,
  pyarrow,
  numpy,
  geopandas,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "geoarrow-pandas";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geoarrow";
    repo = "geoarrow-python";
    rev = "refs/tags/${pname}-${version}";
    hash = "sha256-Ni+GKTRhRDRHip1us3OZPuUhHQCNU7Nap865T/+CU8Y=";
  };

  sourceRoot = "${src.name}/geoarrow-pandas";
  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    geoarrow-pyarrow
    pandas
    pyarrow
    numpy
    geopandas
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "geoarrow.pandas" ];

  meta = {
    description = "Python implementation of the GeoArrow specification";
    homepage = "https://geoarrow.org/geoarrow-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
