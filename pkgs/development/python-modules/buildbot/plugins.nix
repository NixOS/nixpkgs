{ lib, buildPythonPackage, fetchPypi, buildbot, buildbot-pkg }:

{
  www = buildPythonPackage rec {
    pname = "buildbot_www";
    inherit (buildbot-pkg) version;

    # NOTE: wheel is used due to buildbot circular dependency
    format = "wheel";

    src = fetchPypi {
      inherit pname version format;
      sha256 = "03cgjhwpgbm0qgis1cdy9g4vc11hsrya9grcx4j35784rny7lbfl";
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
      sha256 = "0pfp2n4ys99jglshdrp2f6jm73c4ym3dfwl6qjvbc7y7nsi74824";
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
      sha256 = "0gnxq9niw64q36dm917lhhcl8zp0wjwaamjp07zidnrb5c3pjbsz";
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
      sha256 = "1b06aa8m1pzqq2d8imrq5mazc7llrlbgm7jzi8h6jjd2gahdjgz5";
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
      sha256 = "1v8411bw0cs206vwfnqx1na7dzg77h9aff4wlm11hkbdsy9ayv2d";
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
