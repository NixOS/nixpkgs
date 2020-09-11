{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_core_components";
  version = "1.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6152346ff2ac8a7fcdb76c8b8acbf3ee4e72f3822cd2a02a9f3a963db66f94a3";
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
