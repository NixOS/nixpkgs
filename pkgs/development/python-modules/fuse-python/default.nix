{ stdenv, buildPythonPackage, fetchPypi, pkgconfig, fuse }:

buildPythonPackage rec {
  pname = "fuse-python";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbaa21c8f0a440302d1ba9fd57a80cf9ff227e5a3820708a8ba8450db883cc05";
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

