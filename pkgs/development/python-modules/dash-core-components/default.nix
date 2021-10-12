{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_core_components";
  version = "1.17.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-flA/Xt22MDTdIMI9IYzA2KgeyI6aFbfLxg4maw4rYKk=";
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
