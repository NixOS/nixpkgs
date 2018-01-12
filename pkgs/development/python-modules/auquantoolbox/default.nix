{ stdenv, lib, fetchPypi, python, buildPythonPackage, requests, pandas, numpy,
pandas-datareader, requests-file, requests-ftp, plotly }:

buildPythonPackage rec {
  pname = "auquan_toolbox";
  version = "2.0.8";

  src = fetchPypi {
    inherit pname version;
    extension = "tar.gz";
    sha256 = "1w1pck5mlz8hrb6rxvmipm5z9xzln9c6clkn7rzi4gl4rm42nlcl";
  };

  propagatedBuildInputs = [
    requests pandas numpy pandas-datareader requests-file requests-ftp plotly
  ];

  meta = {
    description = "Auquan Toolbox for developing strategies and backtesting.";
    homepage = http://toolbox.auquan.com/;
    license = stdenv.lib.licenses.asl20;
  };
}
