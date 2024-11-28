{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  pyarrow,
  cython,
  numpy,
  setuptools,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "geoarrow-c";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "geoarrow-c";
    owner = "geoarrow";
    rev = "refs/tags/geoarrow-c-python-${version}";
    hash = "sha256-kQCD3Vptl7GtRFigr4darvdtwnaHRLZWvBBpZ0xHMgM=";
  };

  sourceRoot = "${src.name}/python/geoarrow-c";

  build-system = [
    cython
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeCheckInputs = [
    pytestCheckHook
    pyarrow
    numpy
  ];

  pythonImportsCheck = [ "geoarrow.c" ];

  meta = with lib; {
    description = "Experimental C and C++ implementation of the GeoArrow specification";
    homepage = "https://github.com/geoarrow/geoarrow-c";
    license = licenses.asl20;
    maintainers = with maintainers; [
      cpcloud
    ];
  };
}
