{ lib
, buildPythonPackage
, fetchPypi
, pytz
, requests
, six
, tenacity
}:

buildPythonPackage rec {
  pname = "plotly";
  version = "5.19.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XqkaVlcSkq3j47yb9xLroLlaH7CpQTddl4zHlDLgVfQ=";
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
