{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "hpack";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8eec9c1f4bfae3408a3f30500261f7e6a65912dc138526ea054f9ad98892e9d2";
  };

  meta = with stdenv.lib; {
    description = "Pure-Python HPACK header compression";
    homepage = "http://hyper.rtfd.org";
    license = licenses.mit;
  };

}
