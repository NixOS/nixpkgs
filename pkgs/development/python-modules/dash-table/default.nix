{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_table";
  version = "4.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1aa02180faef13434364286b60404d26164d1ce2779c765c9c52e6935991a4e9";
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
