{ lib, buildPythonPackage, fetchPypi, matplotlib, pandas }:

buildPythonPackage rec {
  pname = "mplfinance";
  version = "0.12.7a7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pATiprTELt8GrEkeKjILPfpdNDVoex5t+Mc+6Gg7cPY=";
  };

  propagatedBuildInputs = [ matplotlib pandas ];

  meta = with lib; {
    description =
      "Matplotlib utilities for the visualization, and visual analysis, of financial data";
    homepage = "https://github.com/matplotlib/mplfinance";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.ehmry ];
  };
}
