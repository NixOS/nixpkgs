{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_renderer";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ccsykv24dz9xj24106aaj7f0w7x7sv7mamjbx0m6k0wyhh58vw1";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Renderer for the Dash framework";
    homepage = https://dash.plot.ly/;
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
