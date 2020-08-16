{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ExifRead";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "269ff3a8eab8e082734a076182cce6fb126116619c0b7c2009bea34502cca213";
  };

  meta = with stdenv.lib; {
    description = "Easy to use Python module to extract Exif metadata from tiff and jpeg files";
    homepage    = "https://github.com/ianare/exif-py";
    license     = licenses.bsd0;
    maintainers = with maintainers; [ vozz ];
  };

}
