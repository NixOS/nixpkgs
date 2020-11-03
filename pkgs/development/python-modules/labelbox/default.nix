{ lib
, buildPythonPackage
, fetchPypi
, requests
, jinja2
, pillow
, rasterio
, shapely
}:

buildPythonPackage rec {
  pname = "labelbox";
  version = "2.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a455ae30ccb9328731fca7f7f4cefaa7da69a2fe3e43d1b742bae5ff4693c695";
  };

  propagatedBuildInputs = [ jinja2 requests pillow rasterio shapely ];

  # Test cases are not running on pypi or GitHub
  doCheck = false;

  meta = with lib; {
    broken = true;
    homepage = "https://github.com/Labelbox/Labelbox";
    description = "Platform API for LabelBox";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
