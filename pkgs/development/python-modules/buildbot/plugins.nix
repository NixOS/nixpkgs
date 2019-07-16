{ lib, buildPythonPackage, fetchPypi, buildbot, buildbot-pkg }:

{
  www = buildPythonPackage rec {
    pname = "buildbot_www";
    inherit (buildbot-pkg) version;

    # NOTE: wheel is used due to buildbot circular dependency
    format = "wheel";

    src = fetchPypi {
      inherit pname version format;
      python = "py3";
      sha256 = "1ii01py78wkda9x4lqm0bxqmb4dhvbdmmz7sncm1lw7bhmhqh84w";
    };

    meta = with lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot UI";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      license = licenses.gpl2;
    };
  };

  console-view = buildPythonPackage rec {
    pname = "buildbot-console-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "1y523hadw3398jwfpmi2f4g0s6dp9y191qzycrsbvbj147dp0qra";
    };

    propagatedBuildInputs = [ buildbot-pkg ];
    checkInputs = [ buildbot ];

    meta = with lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Console View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      license = licenses.gpl2;
    };
  };

  waterfall-view = buildPythonPackage rec {
    pname = "buildbot-waterfall-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "1prfr03igcmagydvxqhrh6k6wz16vk6fwgrm143jh3xmml6f16ll";
    };

    propagatedBuildInputs = [ buildbot-pkg ];
    checkInputs = [ buildbot ];

    meta = with lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Waterfall View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      license = licenses.gpl2;
    };
  };

  grid-view = buildPythonPackage rec {
    pname = "buildbot-grid-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "1xkqiwxjppyns2s0239zzvbnr8b7vdakypj95mca89mmnyniflxj";
    };

    propagatedBuildInputs = [ buildbot-pkg ];
    checkInputs = [ buildbot ];

    meta = with lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Grid View Plugin";
      maintainers = with maintainers; [ nand0p ];
      license = licenses.gpl2;
    };
  };

  wsgi-dashboards = buildPythonPackage rec {
    pname = "buildbot-wsgi-dashboards";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "1jhvq61x0bzh03nd2ac11swdjn0ndnx3ac7x9v3m3v0pgr08rc28";
    };

    propagatedBuildInputs = [ buildbot-pkg ];
    checkInputs = [ buildbot ];

    meta = with lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot WSGI dashboards Plugin";
      maintainers = with maintainers; [ ];
      license = licenses.gpl2;
    };
  };
}
