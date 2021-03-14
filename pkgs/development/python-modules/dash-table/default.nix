{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_table";
  version = "4.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90fbdd12eaaf657aa80d429263de4bbeef982649eb5981ebeb2410d67c1d20eb";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A First-Class Interactive DataTable for Dash";
    homepage = "https://dash.plot.ly/datatable";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
