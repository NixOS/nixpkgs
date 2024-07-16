{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytz,
  requests,
  six,
  tenacity,
}:

buildPythonPackage rec {
  pname = "plotly";
  version = "5.22.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hZ/a29hrV3CuJGblQrdhskfRxrSdrtdluVu4xwY+dGk=";
  };

  propagatedBuildInputs = [
    pytz
    requests
    six
    tenacity
  ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Python plotting library for collaborative, interactive, publication-quality graphs";
    downloadPage = "https://github.com/plotly/plotly.py";
    homepage = "https://plot.ly/python/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
  };
}
