{ lib, fetchPypi, buildPythonPackage, pythonOlder, routerFeatures
, janus, ncclient, paramiko, pyyaml, sanic }:

let
  # The `routerFeatures` flag optionally brings in some somewhat heavy
  # dependencies, in order to enable interacting with routers
  opts = if routerFeatures then {
      prePatch = ''
        substituteInPlace ./setup.py --replace "extra_deps = []" "extra_deps = router_feature_deps"
      '';
      extraBuildInputs = [ janus ncclient paramiko ];
    } else {
      prePatch = "";
      extraBuildInputs = [];
    };

in

buildPythonPackage rec {
  pname = "entrance";
  version = "1.1.20";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PvsP6HXCllW102h3o7abz9uC2AZTwvg5qIqP+rdkk6Y=";
  };

  # The versions of `sanic` and `websockets` in nixpkgs only support 3.6 or later
  disabled = pythonOlder "3.6";

  # No useful tests
  doCheck = false;

  propagatedBuildInputs = [ pyyaml sanic ] ++ opts.extraBuildInputs;

  prePatch = opts.prePatch;

  meta = with lib; {
    description = "A server framework for web apps with an Elm frontend";
    homepage = "https://github.com/ensoft/entrance";
    license = licenses.mit;
    maintainers = with maintainers; [ simonchatts ];
  };
}

