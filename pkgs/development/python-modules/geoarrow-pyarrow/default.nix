{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  geoarrow-c,
  pyarrow,
  pyarrow-hotfix,
  pandas,
  numpy,
  pyogrio,
  pyproj,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "geoarrow-pyarrow";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geoarrow";
    repo = "geoarrow-python";
    rev = "refs/tags/${pname}-${version}";
    hash = "sha256-Ni+GKTRhRDRHip1us3OZPuUhHQCNU7Nap865T/+CU8Y=";
  };

  sourceRoot = "${src.name}/${pname}";
  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    geoarrow-c
    pyarrow
    pyarrow-hotfix
    pandas
    numpy
    pyogrio
    pyproj
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "geoarrow.pyarrow" ];

  meta = with lib; {
    description = "Python implementation of the GeoArrow specification";
    homepage = "https://geoarrow.org/geoarrow-pyarrow";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
