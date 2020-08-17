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
  version = "4.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce55e1a9669ea7455574ddbfe2fb52636eb63a6c29387ee0c0a929ed2325f916";
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
