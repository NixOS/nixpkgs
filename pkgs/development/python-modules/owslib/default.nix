{ lib
, buildPythonPackage
, fetchFromGitHub
, pyproj
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, pyyaml
, requests
}:

buildPythonPackage rec {
  pname = "owslib";
  version = "0.26.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "geopython";
    repo = "OWSLib";
    rev = version;
    sha256 = "sha256-IVJMBpjpMHuvHnWwC7oA0ifkuAgYvwGdGDbkX62XEgs=";
  };

  propagatedBuildInputs = [
    python-dateutil
    pyproj
    pytz
    requests
    pyyaml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # Can be removed with the next release: https://github.com/geopython/OWSLib/pull/824
    substituteInPlace requirements.txt \
      --replace 'pyproj ' 'pyproj #'
    # Remove coverage
    rm tox.ini
  '';

  pythonImportsCheck = [
    "owslib"
  ];

  disabledTests = [
    # Tests require network access
    "TestOffline"
    "test_ows_interfaces_wcs"
    "test_wmts_example_informatievlaanderen"
  ];

  meta = with lib; {
    description = "client for Open Geospatial Consortium web service interface standards";
    homepage = "https://www.osgeo.org/projects/owslib/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
