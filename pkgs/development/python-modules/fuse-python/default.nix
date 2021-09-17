{ lib, buildPythonPackage, fetchPypi, pkg-config, fuse }:

buildPythonPackage rec {
  pname = "fuse-python";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b9a69c38b3909ffd35d77cb1a73ebfdc3a103a6d4cdd20c86c70ed1141771580";
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
