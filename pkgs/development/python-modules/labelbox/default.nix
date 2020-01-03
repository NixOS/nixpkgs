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
  version = "2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f97f01bf030b115d8b7f7b12a10ec5efe54750ad66b6b3567550b517a543ad11";
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
