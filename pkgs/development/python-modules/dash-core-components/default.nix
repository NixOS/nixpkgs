{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "dash-core-components";
  version = "1.2.0";

  src = fetchPypi {
    inherit version;
    pname = "dash_core_components";
    sha256 = "910c158081c337c56c6d0a3f617a5bdb275933ffa513ea4ed2448c682650edf6";
  };

  doCheck = false; # no tests

  meta = with lib; {
    description = "A Dash component starter pack";
    homepage = https://github.com/plotly/dash-core-components;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jdehaas ];
  };

}
