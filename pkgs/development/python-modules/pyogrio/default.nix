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
  version = "0.9.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "pyogrio";
    rev = "v${version}";
    hash = "sha256-HC7+dDehDwEIDQnCMYrsC1jE78AyfHqEhfOZLYSzTIw=";
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
  ] ++ versioneer.optional-dependencies.toml;

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

  pytestFlagsArray = [
    # disable tests which require network access
    "-m 'not network'"
  ];

  pythonImportsCheck = [ "pyogrio" ];

  meta = {
    description = "Vectorized spatial vector file format I/O using GDAL/OGR";
    homepage = "https://pyogrio.readthedocs.io/";
    changelog = "https://github.com/geopandas/pyogrio/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = lib.teams.geospatial.members;
  };
}
