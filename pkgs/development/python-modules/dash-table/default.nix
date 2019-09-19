{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash-table";
  version = "4.3.0";

  src = fetchPypi {
    inherit version;
    pname = "dash_table";
    sha256 = "ca6855dcf95136f19e0ab273c48caf8a5529f2a614bbc5ae02c04e5d0284db33";
  };

  doCheck = false; # no tests

  meta = with lib; {
    description = "A first-class interactive DataTable for Dash";
    homepage = https://github.com/plotly/dash-core-components;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jdehaas ];
  };

}
