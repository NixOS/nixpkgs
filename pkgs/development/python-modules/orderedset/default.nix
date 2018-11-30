{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "orderedset";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11643qr12ypxfffcminlsgl9xz751b2d0pnjl6zn8vfhxddjr57f";
  };

  meta = with stdenv.lib; {
    description = "An Ordered Set implementation in Cython";
    homepage = https://pypi.python.org/pypi/orderedset;
    license = licenses.bsd3;
    maintainers = [ maintainers.jtojnar ];
  };
}
