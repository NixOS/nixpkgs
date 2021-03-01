{ lib, buildPythonPackage, fetchPypi, pkg-config, fuse }:

buildPythonPackage rec {
  pname = "fuse-python";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da42d4f596a2e91602bcdf46cc51747df31c074a3ceb78bccc253c483a8a75fb";
  };

  buildInputs = [ fuse ];
  nativeBuildInputs = [ pkg-config ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "fuse" ];

  meta = with lib; {
    description = "Python bindings for FUSE";
    homepage = "https://github.com/libfuse/python-fuse";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ psyanticy ];
  };
}
