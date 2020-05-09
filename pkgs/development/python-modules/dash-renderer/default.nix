{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_renderer";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vb63z3qakx89wwh3zl74g9b4q4lhxh11xsd1yxxgw2znpq5fvn5";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Renderer for the Dash framework";
    homepage = "https://dash.plot.ly/";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
