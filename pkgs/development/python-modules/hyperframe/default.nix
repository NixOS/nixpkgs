{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "hyperframe";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "017vjbb1xjak1pxcvihhilzjnmpfvhapk7k88wp6lvdkkm9l8nd2";
  };

  meta = with stdenv.lib; {
    description = "HTTP/2 framing layer for Python";
    homepage = http://hyper.rtfd.org/;
    license = licenses.mit;
  };
}
