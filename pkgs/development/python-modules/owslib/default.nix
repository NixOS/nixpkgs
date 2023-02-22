{ lib
, buildPythonPackage
, fetchPypi
, pyproj
, pytest
, python-dateutil
, pytz
, pyyaml
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "owslib";
  version = "0.28.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2tA/XZVcFqdjlU1VT2MxjNMDeu96vQj8Vk9eg/cvq5Q=";
  };

  # as now upstream https://github.com/geopython/OWSLib/pull/824
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'pyproj ' 'pyproj #'
  '';

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    pyproj
    python-dateutil
    pytz
    pyyaml
    requests
  ];

  # 'tests' dir not included in pypy distribution archive.
  doCheck = false;

  pythonImportsCheck = [
    "owslib"
  ];

  meta = with lib; {
    description = "client for Open Geospatial Consortium web service interface standards";
    homepage = "https://www.osgeo.org/projects/owslib/";
    changelog = "https://github.com/geopython/OWSLib/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
