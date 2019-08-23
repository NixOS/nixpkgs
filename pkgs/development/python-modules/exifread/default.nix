{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ExifRead";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b90jf6m9vxh9nanhpyvqdq7hmfx5iggw1l8kq10jrs6xgr49qkr";
  };

  meta = with stdenv.lib; {
    description = "Easy to use Python module to extract Exif metadata from tiff and jpeg files";
    homepage    = "https://github.com/ianare/exif-py";
    license     = licenses.bsd0;
    maintainers = with maintainers; [ vozz ];
  };

}
