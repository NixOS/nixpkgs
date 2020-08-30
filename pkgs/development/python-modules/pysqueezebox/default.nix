{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "pysqueezebox";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02d73e98314a63a38c314d40942a0b098fb59d2f08ac39b2627cfa73f785cf0d";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Asynchronous library to control Logitech Media Server";
    homepage = "https://github.com/rajlaud/pysqueezebox";
    license = licenses.asl20;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
