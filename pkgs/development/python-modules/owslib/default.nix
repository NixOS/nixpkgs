{ lib, buildPythonPackage, fetchPypi, python-dateutil, requests, pytz, pyproj , pytest, pyyaml } :
buildPythonPackage rec {
  pname = "OWSLib";
  version = "0.27.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4QKqJETf4MhDmrHhd2zA+kfOoowJuKKCEsiTxgF8F5s=";
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
    license = licenses.bsd3;
    homepage = "https://www.osgeo.org/projects/owslib/";
  };
}
