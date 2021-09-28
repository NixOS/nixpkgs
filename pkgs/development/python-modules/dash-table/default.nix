{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_table";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18624d693d4c8ef2ddec99a6f167593437a7ea0bf153aa20f318c170c5bc7308";
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
