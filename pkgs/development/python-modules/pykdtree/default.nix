{ lib, buildPythonPackage, fetchPypi, numpy, pytestCheckHook, openmp }:

buildPythonPackage rec {
  pname = "pykdtree";
  version = "1.3.7.post0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7KHWHTPbYh74An62ka6I25xl0ZarpLLMkMGQy5C7UI4=";
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
