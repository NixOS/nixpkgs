{ stdenv
, buildPythonPackage
, fetchurl
}:

buildPythonPackage rec {
  pname = "mox";
  version = "0.5.3";

  src = fetchurl {
    url = "http://pymox.googlecode.com/files/${pname}-${version}.tar.gz";
    sha256 = "4d18a4577d14da13d032be21cbdfceed302171c275b72adaa4c5997d589a5030";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://pymox.readthedocs.io/";
    description = "A mock object framework for Python";
    license = licenses.asl20;
  };

}
