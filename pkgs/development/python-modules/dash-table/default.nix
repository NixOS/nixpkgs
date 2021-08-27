{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_table";
  version = "4.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TJlomoh7/QNSeLFOzV23BwYCM4nlNzXV48zMQW+s2+Q=";
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
