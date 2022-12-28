{ lib, buildPythonPackage, fetchPypi, numpy, pytestCheckHook, openmp }:

buildPythonPackage rec {
  pname = "pykdtree";
  version = "1.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-c0L3XnMRA+ZT/B9rn9q8JBDPkrbnsGFggEp1eGybV0c=";
  };

  buildInputs = [ openmp ];

  propagatedBuildInputs = [ numpy ];

  preCheck = ''
    # make sure we don't import pykdtree from the source tree
    mv pykdtree tests
  '';

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "kd-tree implementation for fast nearest neighbour search in Python";
    homepage = "https://github.com/storpipfugl/pykdtree";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ psyanticy ];
  };
}
