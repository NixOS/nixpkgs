{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, setuptools
, numpy
, xarray
, matplotlib
, cartopy
, pip
, setuptools-scm
}:

let
  pname = "geocat.viz";
  version = "2023.10.0";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";
  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IX/c82KGGsNr25FNKF7EqI8GYzv/b45Pqn9csqnfYtU=";
  };

  nativeBuildInputs = [
    setuptools
    pip
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    xarray
    matplotlib
    cartopy
  ];

  meta = with lib; {
    description = "The GeoCAT-viz repo contains tools to help plot data, including convenience and plotting functions that are used to facilitate plotting geosciences data with Matplotlib, Cartopy, and possibly other Python ecosystem plotting packages";
    homepage = "https://github.com/NCAR/geocat-viz";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfvillablanca ];
  };
}
