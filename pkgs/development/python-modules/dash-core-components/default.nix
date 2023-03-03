{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash-core-components";
  version = "2.0.0";

  src = fetchPypi {
    pname = "dash_core_components";
    inherit version;
    sha256 = "sha256-xnM4dK+XXlUvlaE5ihbC7n3xTOQ/pguzcYo8bgtj/+4=";
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
