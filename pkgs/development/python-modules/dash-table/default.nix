{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash-table";
  version = "5.0.0";

  src = fetchPypi {
    pname = "dash_table";
    inherit version;
    hash = "sha256-GGJNaT1MjvLd7Jmm8WdZNDen6gvxU6og8xjBcMW8cwg=";
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
