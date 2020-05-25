{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_table";
  version = "4.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hn1yjz5ig2kzkk0wkr75q3l4lrfbnsh0kxzlld9sfn69d1vvsjw";
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
