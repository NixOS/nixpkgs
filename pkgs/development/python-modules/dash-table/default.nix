{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_table";
  version = "4.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0md7qqjpsarc8ymfccvsqgj6mgq8gxl09im5v5yxhv8hv24yy4jm";
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
