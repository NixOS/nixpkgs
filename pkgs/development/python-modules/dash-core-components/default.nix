{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash_core_components";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qqf51mphv1pqqc2ff50rkbw44sp9liifg0mg7xkh41sgnv032cs";
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
