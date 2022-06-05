{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ExifRead";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0f74af5040168d3883bbc980efe26d06c89f026dc86ba28eb34107662d51766";
  };

  meta = with lib; {
    description = "Easy to use Python module to extract Exif metadata from tiff and jpeg files";
    homepage    = "https://github.com/ianare/exif-py";
    license     = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };

}
