{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  hatchling,

  h5py,
  numpy,
  tqdm,
}:

buildPythonPackage rec {
  pname = "emdfile";
  version = "0.0.16";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9HcEftAMXHHMfuLGUBuK49UR5fcZzOw8OkbjIDhC1u8=";
  };

  disabled = pythonOlder "3.8";

  build-system = [
    hatchling
  ];

  dependencies = [
    h5py
    numpy
    tqdm
  ];

  pythonImportsCheck = [ "emdfile" ];

  meta = with lib; {
    description = "An interface for moving data between Python and EMD 1.0 formatted HDF5 files. EMD (Electron Microscopy Dataset) 1.0 is a file specification designed to carry arbitrary data and metadata in tree-like hierarchies.";
    homepage = "https://github.com/py4dstem/emdfile";
    license = licenses.mit;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
