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
      sha256 = "134b8y498bq5fp4863hj9058wr7mcw0xgl74br0f1dy9n7jdcl39";
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
      sha256 = "1yh8xij3wizz0f88chjpdijm7i35ql87g84ph3f76sqyr6aj6ckw";
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
      sha256 = "04iihy1s9r4n5jlk57pdjy3yvp6zym2iv2bgqjhw6fy0hff5j8ys";
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
      sha256 = "0bcilhcz9xnr8799d5j4sm6qz8pdjlckdck7a282nfs64liajsrh";
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
      sha256 = "13lr7lzi9sv0s6xrfalq0dkcys6fp7hn0787rjhnz9gc7x83aqjv";
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
