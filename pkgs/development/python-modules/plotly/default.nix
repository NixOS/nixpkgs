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
  version = "4.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "20df14f7883807f57d96ac245841e086a1799f2c2778462a7f3bca704e369c66";
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
