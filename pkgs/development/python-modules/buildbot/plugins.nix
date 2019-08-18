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
      sha256 = "01jx34in0kwhpi2p8p6wl1h40gv3rmfhwaxrvd9kfy4ymqh8b81z";
    };

    meta = with lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot UI";
      maintainers = with maintainers; [ nand0p ryansydnor lopsided98 ];
      license = licenses.gpl2;
    };
  };

  console-view = buildPythonPackage rec {
    pname = "buildbot-console-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "0p7az9mb09c4bl0j37w28wflzygq9vy8rjbbnhlfbs6py6mjdagr";
    };

    propagatedBuildInputs = [ buildbot-pkg ];
    checkInputs = [ buildbot ];

    meta = with lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Console View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor lopsided98 ];
      license = licenses.gpl2;
    };
  };

  waterfall-view = buildPythonPackage rec {
    pname = "buildbot-waterfall-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "0ba0a7q7ii7sipvifxs9ldkcs4b975skndarmirbphc797993hj1";
    };

    propagatedBuildInputs = [ buildbot-pkg ];
    checkInputs = [ buildbot ];

    meta = with lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Waterfall View Plugin";
      maintainers = with maintainers; [ nand0p ryansydnor lopsided98 ];
      license = licenses.gpl2;
    };
  };

  grid-view = buildPythonPackage rec {
    pname = "buildbot-grid-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "0dvchhjzmfbbrxqm8dlmwck22z99pgnflxk3cyn0wbb1qskhd9cv";
    };

    propagatedBuildInputs = [ buildbot-pkg ];
    checkInputs = [ buildbot ];

    meta = with lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot Grid View Plugin";
      maintainers = with maintainers; [ nand0p lopsided98 ];
      license = licenses.gpl2;
    };
  };

  wsgi-dashboards = buildPythonPackage rec {
    pname = "buildbot-wsgi-dashboards";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "0w9p3y89rqsmqiacwj2avir42r0xjr2yri14v3ay6yar5391r8wa";
    };

    propagatedBuildInputs = [ buildbot-pkg ];
    checkInputs = [ buildbot ];

    meta = with lib; {
      homepage = http://buildbot.net/;
      description = "Buildbot WSGI dashboards Plugin";
      maintainers = with maintainers; [ lopsided98 ];
      license = licenses.gpl2;
    };
  };
}
