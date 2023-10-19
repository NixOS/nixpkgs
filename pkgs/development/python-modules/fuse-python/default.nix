{ stdenv, lib, buildPythonPackage, fetchPypi, pkg-config, fuse }:

buildPythonPackage rec {
  pname = "fuse-python";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dOX/szaCu6mlrypaBI9Ht+e0ZOv4QpG/WiWL+60Do6o=";
  };

  buildInputs = [ fuse ];
  nativeBuildInputs = [ pkg-config ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "fuse" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Python bindings for FUSE";
    homepage = "https://github.com/libfuse/python-fuse";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ psyanticy ];
  };
}
