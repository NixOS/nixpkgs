{ lib, buildPythonPackage, fetchPypi, numpy, nose, openmp }:

buildPythonPackage rec {
  pname = "pykdtree";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bebe5c608129f2997e88510c00010b9a78581b394924c0e3ecd131d52415165d";
  };

  buildInputs = [ openmp ];

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ nose ];

  meta = with lib; {
    description = "kd-tree implementation for fast nearest neighbour search in Python";
    homepage = "https://github.com/storpipfugl/pykdtree";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ psyanticy ];
  };
}
