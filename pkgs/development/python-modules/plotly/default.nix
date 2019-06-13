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
  version = "3.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "498c35a2a482f7c7937fc2f3681fec653a0191dd21e40e754a6b774234cd167e";
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
    homepage = https://plot.ly/python/;
    license = with lib.licenses; [ mit ];
  };
}
