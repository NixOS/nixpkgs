{
  lib,
  buildPythonPackage,
  fetchPypi,

  numpy,
  pandas,
  matplotlib,
  pyfftw,
  scipy,
  numba,
  dask,
  distributed,
  zarr,
  ase,
  threadpoolctl,
  tabulate,
  ipywidgets,
  ipympl,
  tqdm,
}:

buildPythonPackage rec {
  pname = "abtem";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S+7S9UBaWLdlWH4/hxZMMhQEbq6sL3SAxiMoWbXxmZY=";
  };

  dependencies = [
    numpy
    pandas
    matplotlib
    pyfftw
    scipy
    numba
    dask
    distributed
    zarr
    ase
    threadpoolctl
    tabulate
    ipywidgets
    ipympl
    tqdm
  ];

  pythonImportsCheck = [ "abtem" ];

  meta = with lib; {
    description = "Provides a Python API for running simulations of (scanning) transmission electron microscopy images and diffraction patterns using the multislice or PRISM algorithms";
    homepage = "https://github.com/abTEM/abTEM";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
