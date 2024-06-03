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
  version = "5.21.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aSQ/jBZdS+JsDfHG8LeyWOLf7v4DJ2NAStfn+318IHM=";
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
