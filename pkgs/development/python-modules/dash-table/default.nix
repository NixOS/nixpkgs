{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_table";
  version = "4.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3170504a8626a9676b016c5ab456ab8c1fb1ea0206dcc2eddb8c4c6589216304";
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
