{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  dask,
  diffsims,
  hyperspy,
  h5py,
  lmfit,
  matplotlib,
  numba,
  numpy,
  orix,
  pooch,
  psutil,
  scikit-image,
  scikit-learn,
  shapely,
  scipy,
  tqdm,
  traits,
  transforms3d,
  zarr,
}:

buildPythonPackage rec {
  pname = "pyxem";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QslpK528yH+loqtkuxF9jk5e0E3WnMKjLKNjMBMoXwU=";
  };

  disabled = pythonOlder "3.7";

  dependencies = [
    dask
    diffsims
    hyperspy
    h5py
    lmfit
    matplotlib
    numba
    numpy
    orix
    pooch
    psutil
    scikit-image
    scikit-learn
    shapely
    scipy
    tqdm
    traits
    (transforms3d.overrideAttrs (oldAttrs: {
      doCheck = false;
      doInstallCheck = false;
    })) # Issue with transforms3d package tests, will evaluate if this override is still needed with updates
    zarr
  ];

  preInstallCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "pyxem" ];

  meta = with lib; {
    description = "Python library for multi-dimensional diffraction microscopy";
    homepage = "https://pyxem.readthedocs.io";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      classic-ally
      hcenge
    ];
  };
}
