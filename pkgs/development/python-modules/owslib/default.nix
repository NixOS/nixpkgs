{ lib, buildPythonPackage, fetchPypi, python-dateutil, requests, pytz, pyproj , pytest, pyyaml } :
buildPythonPackage rec {
  pname = "OWSLib";
  version = "0.28.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2tA/XZVcFqdjlU1VT2MxjNMDeu96vQj8Vk9eg/cvq5Q=";
  };

  # as now upstream https://github.com/geopython/OWSLib/pull/824
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace 'pyproj ' 'pyproj #'
  '';

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ python-dateutil pyproj pytz requests pyyaml ];

  # 'tests' dir not included in pypy distribution archive.
  doCheck = false;

  meta = with lib; {
    description = "client for Open Geospatial Consortium web service interface standards";
    homepage = "https://www.osgeo.org/projects/owslib/";
    changelog = "https://github.com/geopython/OWSLib/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
