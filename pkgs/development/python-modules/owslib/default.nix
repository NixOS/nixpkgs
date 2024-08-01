{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  lxml,
  pyproj,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pytz,
  pyyaml,
  requests,
}:

buildPythonPackage rec {
  pname = "owslib";
  version = "0.31.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "geopython";
    repo = "OWSLib";
    rev = version;
    hash = "sha256-vjJsLavVOqTTrVtYbtA0G+nl0HanKeGtzNFFj92Frw8=";
  };

  postPatch = ''
    substituteInPlace tox.ini \
      --replace " --doctest-modules --doctest-glob 'tests/**/*.txt' --cov-report term-missing --cov owslib" ""
  '';

  propagatedBuildInputs = [
    lxml
    pyproj
    python-dateutil
    pytz
    pyyaml
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "owslib" ];

  preCheck = ''
    # _pytest.pathlib.ImportPathMismatchError: ('owslib.swe.sensor.sml', '/build/source/build/...
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  pytestFlagsArray = [
    # disable tests which require network access
    "-m 'not online'"
  ];

  meta = with lib; {
    description = "Client for Open Geospatial Consortium web service interface standards";
    homepage = "https://www.osgeo.org/projects/owslib/";
    changelog = "https://github.com/geopython/OWSLib/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
  };
}
