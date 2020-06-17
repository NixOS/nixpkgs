{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_core_components";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bqvxm7h3b0wah32jrsn919hp4xr1zlkxclbs261mvd57ps0rf9h";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A dash component starter pack";
    homepage = "https://dash.plot.ly/dash-core-components";
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
