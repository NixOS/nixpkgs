{ lib, buildPythonPackage, fetchPypi, numpy, pytestCheckHook, openmp }:

buildPythonPackage rec {
  pname = "pykdtree";
  version = "1.3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QefF1mnK3CGIrMS7tLC03K9JLYRRLx5lF6erLRIskR0=";
  };

  buildInputs = [ openmp ];

  propagatedBuildInputs = [ numpy ];

  preCheck = ''
    # make sure we don't import pykdtree from the source tree
    mv pykdtree tests
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "kd-tree implementation for fast nearest neighbour search in Python";
    homepage = "https://github.com/storpipfugl/pykdtree";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ psyanticy ];
  };
}
