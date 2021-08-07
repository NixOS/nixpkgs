{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_table";
  version = "4.11.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a4f22a5cf5120882a252a3348fc15ef45a1b75bf900934783e338aceac52f56";
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
