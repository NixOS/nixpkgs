{
  lib,
  buildPythonPackage,
  fetchPypi,
  matplotlib,
  pandas,
}:

buildPythonPackage rec {
  pname = "mplfinance";
  version = "0.12.10b0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-faFQtYUapRGa1uBrVeSDOLYZu2dz8bhd9d5npf/ZF78=";
  };

  propagatedBuildInputs = [
    matplotlib
    pandas
  ];

  # tests are only included on GitHub where this version misses a tag
  # and half of them fail
  doCheck = false;

  pythonImportsCheck = [ "mplfinance" ];

  meta = with lib; {
    description = "Matplotlib utilities for the visualization, and visual analysis, of financial data";
    homepage = "https://github.com/matplotlib/mplfinance";
    license = [ licenses.bsd3 ];
  };
}
