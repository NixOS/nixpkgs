{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "bz2file";
  version = "0.98";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "126s53fkpx04f33a829yqqk8fj4png3qwg4m66cvlmhmwc8zihb4";
  };

  doCheck = false;
  # The test module (test_bz2file) is not available

  meta = {
    description = "Bz2file is a Python library for reading and writing bzip2-compressed files";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jyp ];
  };
}
