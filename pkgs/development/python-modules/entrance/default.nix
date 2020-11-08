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
  version = "1.1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1fc9d128ce05837d7e149413fbec71bcf84d9ca510accea56761d3f4bd0a021";
  };

  # The versions of `sanic` and `websockets` in nixpkgs only support 3.6 or later
  disabled = pythonOlder "3.6";

  # No useful tests
  doCheck = false;

  requiredPythonModules = [ pyyaml sanic ] ++ opts.extraBuildInputs;

  prePatch = opts.prePatch;

  meta = with lib; {
    description = "A server framework for web apps with an Elm frontend";
    homepage = "https://github.com/ensoft/entrance";
    license = licenses.mit;
    maintainers = with maintainers; [ simonchatts ];
  };
}

