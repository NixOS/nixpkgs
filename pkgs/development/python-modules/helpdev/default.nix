{ lib
, buildPythonPackage
, fetchPypi
, importlib-metadata
, psutil
}:

buildPythonPackage rec {
  pname = "helpdev";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gfvj28i82va7c264jl2p4cdsl3lpf9fpb9cyjnis55crfdafqmv";
  };

  propagatedBuildInputs = [
    importlib-metadata
    psutil
  ];

  # No tests included in archive
  doCheck = false;

  meta = {
    description = "Extracts information about the Python environment easily";
    license = lib.licenses.mit;
  };

}
