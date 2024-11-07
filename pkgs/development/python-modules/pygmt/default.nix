{
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  gmt,
  numpy,
  netcdf4,
  pandas,
  packaging,
  xarray,
  pytest-mpl,
  ipython,
  ghostscript,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pygmt";
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "GenericMappingTools";
    repo = "pygmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-DO9KUlmt5EV+ioOSQ/BOcx4pP409f94dzmFwqK2MwMY=";
  };

  postPatch = ''
    substituteInPlace pygmt/clib/loading.py \
      --replace-fail "env.get(\"GMT_LIBRARY_PATH\")" "env.get(\"GMT_LIBRARY_PATH\", \"${gmt}/lib\")"
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    numpy
    netcdf4
    pandas
    packaging
    xarray
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mpl
    ghostscript
    ipython
  ];

  # The *entire* test suite requires network access
  doCheck = false;

  postBuild = ''
    export HOME=$TMP
  '';

  pythonImportsCheck = [ "pygmt" ];

  meta = with lib; {
    description = "Python interface for the Generic Mapping Tools";
    homepage = "https://github.com/GenericMappingTools/pygmt";
    license = licenses.bsd3;
    changelog = "https://github.com/GenericMappingTools/pygmt/releases/tag/v${version}";
    maintainers = with maintainers; teams.geospatial.members;
  };
}
