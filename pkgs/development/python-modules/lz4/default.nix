{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "lz4";
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1irad4sq4hdr30fr53smvv3zzk4rddcf9b4jx19w8s9xsxhr1x3b";
  };

  buildInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Compression library";
    homepage = https://github.com/python-lz4/python-lz4;
    license = licenses.bsd3;
  };

}
