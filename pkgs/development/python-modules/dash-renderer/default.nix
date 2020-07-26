{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_renderer";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16x8fp94ilp8cj668q3z28zfrdn2f9gq4c5s5wnp6rwjwvmraw89";
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
