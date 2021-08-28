{ lib
, buildPythonPackage
, fetchPypi
, decorator
, nbformat
, pytz
, requests
, retrying
, six
}:

buildPythonPackage rec {
  pname = "plotly";
  version = "4.14.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14cxlfl79i9bh3awsf4xgwr14ywm7lnrz2a81s7gp0if77nsx2kx";
  };

  propagatedBuildInputs = [
    decorator
    nbformat
    pytz
    requests
    retrying
    six
  ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Python plotting library for collaborative, interactive, publication-quality graphs";
    homepage = "https://plot.ly/python/";
    license = with lib.licenses; [ mit ];
  };
}
