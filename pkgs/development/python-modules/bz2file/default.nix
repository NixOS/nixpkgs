{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "bz2file";
  version = "0.98";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZMH4EeMVVrqZMZU8jsezl0iHJsY+CaTGcAT0O90o2og=";
  };

  doCheck = false;
  # The test module (test_bz2file) is not available

  meta = {
    description = "Bz2file is a Python library for reading and writing bzip2-compressed files";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jyp ];
  };
}
