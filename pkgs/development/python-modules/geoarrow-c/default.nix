{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pyarrow,
  cython,
  numpy,
  setuptools,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "geoarrow-c";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "geoarrow-c";
    owner = "geoarrow";
    tag = "geoarrow-c-python-${version}";
    hash = "sha256-cSvFCIMHuwDh83DT3R3V86S+RjPzhqcnTaFXqKL43Ns=";
  };

  sourceRoot = "${src.name}/python/geoarrow-c";

  preConfigure = ''
    export CFLAGS="-I../../src/src/geoarrow"
  '';

  build-system = [
    cython
    setuptools
    setuptools-scm
  ];

  # upstream needs a bootstrap.py file to copy some source around to build the project.
  # This file is executed by setup.py, so at build time, when sources are readonly!
  # So we execute this file at patch time instead, and remove it to prevent setup.py to execute it again.
  postPatch = ''
    python ./bootstrap.py
    rm -v ./bootstrap.py
  '';

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeCheckInputs = [
    pytestCheckHook
    pyarrow
    numpy
  ];

  pythonImportsCheck = [ "geoarrow.c" ];

  meta = {
    description = "Experimental C and C++ implementation of the GeoArrow specification";
    homepage = "https://github.com/geoarrow/geoarrow-c";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cpcloud
    ];
    teams = [ lib.teams.geospatial ];
  };
}
