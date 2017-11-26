{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
}:

buildPythonPackage rec {
  pname = "ruffus";
  version = "2.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qah7rzf9p1l8sj0z19lfyb9dqdwv9a9b4sybv8r2g810bc2i1yp";
  };

  meta = with stdenv.lib; {
    homepage = http://www.ruffus.org.uk/;
    description = "A Computation Pipeline library for python.";
    license = licenses.mit;
    maintainers = with maintainers; [ hyper_ch ];
  };
}
