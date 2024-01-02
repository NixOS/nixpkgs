{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, lxml
, pyproj
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, pyyaml
, requests
, python
}:

buildPythonPackage rec {
  pname = "owslib";
  version = "0.29.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "geopython";
    repo = "OWSLib";
    rev = "refs/tags/${version}";
    hash = "sha256-yAJXknSsGXcerzaOVSrFO4j5E6B/4/0JfoSxZ+Szmws=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "owslib"
  ];

  preCheck = ''
    # _pytest.pathlib.ImportPathMismatchError: ('owslib.swe.sensor.sml', '/build/source/build/...
    export PY_IGNORE_IMPORTMISMATCH=1
  '';

  disabledTests = [
    # Tests require network access
    "test_ows_interfaces_wcs"
    "test_wfs_110_remotemd"
    "test_wfs_200_remotemd"
    "test_wms_130_remotemd"
    "test_wmts_example_informatievlaanderen"
    "test_opensearch_creodias"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_ogcapi_processes_pygeoapi"
    "test_ogcapi_records_pycsw"
    "test_ogcapi_records_pygeoapi"
    "test_wms_getfeatureinfo_130"
  ];

  meta = with lib; {
    description = "Client for Open Geospatial Consortium web service interface standards";
    homepage = "https://www.osgeo.org/projects/owslib/";
    changelog = "https://github.com/geopython/OWSLib/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
  };
}
