{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  cython,
  pyarrow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "geoarrow-c";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "geoarrow";
    repo = "geoarrow-c";
    rev = "refs/tags/v${version}";
    hash = "sha256-uEB+D3HhrjnCgExhguZkmvYzULWo5gAWxXeIGQOssqo=";
  };

  sourceRoot = "${src.name}/python/geoarrow-c";
  build-system = [
    setuptools
    setuptools-scm
    cython
  ];

  dependencies = [ pyarrow ];

  pythonImportsCheck = [
    "geoarrow.c"
    "geoarrow.c.lib"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Experimental C and C++ implementation of the GeoArrow specification";
    homepage = "https://geoarrow.org/geoarrow-c";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
