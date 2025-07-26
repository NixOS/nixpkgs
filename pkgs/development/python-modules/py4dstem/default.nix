{
  lib,
  buildPythonPackage,
  fetchPypi,

  numpy,
  scipy,
  h5py,
  hdf5plugin,
  ncempy,
  matplotlib,
  scikit-image,
  scikit-learn,
  scikit-optimize,
  tqdm,
  dill,
  gdown,
  dask,
  distributed,
  emdfile,
  mpire,
  threadpoolctl,
  pylops,
  colorspacious,
}:

buildPythonPackage rec {
  pname = "py4dstem";
  version = "0.14.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-m+3uWZRYKzqUg+kxNY+iZypQvU+UC4As79g3gNX4+d8=";
  };

  dependencies = [
    numpy
    scipy
    h5py
    hdf5plugin
    ncempy
    matplotlib
    scikit-image
    scikit-learn
    scikit-optimize
    tqdm
    dill
    gdown
    dask
    distributed
    emdfile
    mpire
    threadpoolctl
    pylops
    colorspacious
  ];

  pythonImportsCheck = [ "py4DSTEM" ];

  meta = with lib; {
    description = "Set of Python tools for processing and analysis of four-dimensional scanning transmission electron microscopy (4D-STEM) data";
    homepage = "https://github.com/py4dstem/py4DSTEM";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
