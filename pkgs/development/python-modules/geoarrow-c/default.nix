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
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "geoarrow-c";
    owner = "geoarrow";
    tag = "geoarrow-c-python-${version}";
    hash = "sha256-IT3lwJ0n6hdcfq9/B4Iwr9R8V3XGQ1vU1vycvPDomuw=";
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
  patches = [
    # see https://github.com/geoarrow/geoarrow-c/issues/145
    ./cython_version.patch
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
    teams = [ lib.teams.geospatial ];
  };
}
