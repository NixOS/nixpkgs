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
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b515dc29329e8a3adac9d6b4fef84d80c513743be57ae66b54bcb30060172c6";
  };

  propagatedBuildInputs = [ jinja2 requests pillow rasterio shapely ];

  # Test cases are not running on pypi or GitHub
  doCheck = false;   

  meta = with lib; {
    homepage = https://github.com/Labelbox/Labelbox;
    description = "Platform API for LabelBox";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
