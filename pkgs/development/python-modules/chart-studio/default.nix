{ lib, buildPythonPackage, fetchPypi
, plotly
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "chart-studio";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qv5xsa1rplbmn5c02nbp01l2ydhydq3vhqqz4zvnlm5adjpg4qj";
  };

  propagatedBuildInputs = [ plotly ];

  # Packaged from the plotly repo, no good way to retrieve only chart-studio tests
  doCheck = false;

  meta = with lib; {
    description = "Utilities for interfacing with plotly's Chart Studio";
    homepage = https://plot.ly/python/;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
