{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_table";
  version = "4.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xwwkp7zsmrcnl3fswm5f319cxk7hk4dzacvfsarll2b47rmm434";
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
