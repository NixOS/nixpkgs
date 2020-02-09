{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_table";
  version = "4.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01wzac09ac6nr27if1liaxafzdf67x00vw1iq5vaad1147rdh36k";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A First-Class Interactive DataTable for Dash";
    homepage = https://dash.plot.ly/datatable;
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
