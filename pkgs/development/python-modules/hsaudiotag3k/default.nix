{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "hsaudiotag3k";
  version = "1.1.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bv5k5594byr2bmhh77xv10fkdpckcmxg3w380yp30aqf83rcsx3";
  };

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A pure Python library that lets one to read metadata from media files";
    homepage = http://hg.hardcoded.net/hsaudiotag/;
    license = licenses.bsd3;
  };

}
