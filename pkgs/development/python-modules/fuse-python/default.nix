{ stdenv, buildPythonPackage, fetchPypi, pkgconfig, fuse }:

buildPythonPackage rec {
  pname = "fuse-python";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p1f01gah1y8skirrwsbxapz3g6drqihnkjh27b45ifg43h45g7x";
  };

  buildInputs = [ fuse ];
  nativeBuildInputs = [ pkgconfig ];
  
  # no tests in the Pypi archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python bindings for FUSE";
    homepage = https://github.com/libfuse/python-fuse;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ psyanticy ];
  };
}

