{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_core_components";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16jjanq4glj6c2cwyw94954hrqqv49fknisbxj03lfmflg61j32k";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A dash component starter pack";
    homepage = https://dash.plot.ly/dash-core-components;
    license = licenses.mit;
    maintainers = [ maintainers.antoinerg ];
  };
}
