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
  version = "4.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6ad5c3d2cbf056a782e3c6833a334c45a5453a12dc8a48df971602509e8d3d6";
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
