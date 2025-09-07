{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  certifi,
  cython,
  gdal,
  numpy,
  packaging,
  setuptools,
  versioneer,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyogrio";
  version = "0.11.1";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "pyogrio";
    tag = "v${version}";
    hash = "sha256-F6XfkihN3k2xquYS8jJMlqtLXzaTORaduJ2Q9LhSQGM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "versioneer[toml]==0.28" "versioneer[toml]"
  '';

  nativeBuildInputs = [
    cython
    gdal # for gdal-config
    setuptools
    versioneer
    wheel
  ]
  ++ versioneer.optional-dependencies.toml;

  buildInputs = [ gdal ];

  propagatedBuildInputs = [
    certifi
    numpy
    packaging
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    python setup.py build_ext --inplace
  '';

  disabledTestMarks = [
    # disable tests which require network access
    "network"
  ];

  pythonImportsCheck = [ "pyogrio" ];

  meta = {
    description = "Vectorized spatial vector file format I/O using GDAL/OGR";
    homepage = "https://pyogrio.readthedocs.io/";
    changelog = "https://github.com/geopandas/pyogrio/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
  };
}
