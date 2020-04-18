{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "orderedset";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0abf19w37kxypsj6v7dz79jj92y1kivjk2zivnrv7rw6bbxwrxdj";
  };

  meta = with stdenv.lib; {
    description = "An Ordered Set implementation in Cython";
    homepage = "https://pypi.python.org/pypi/orderedset";
    license = licenses.bsd3;
    maintainers = [ maintainers.jtojnar ];
  };
}
