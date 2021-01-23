{ lib, buildPythonPackage, fetchPypi, buildbot-pkg, mock }:

{
  www = buildPythonPackage rec {
    pname = "buildbot-www";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "0bzn00qqx0xd9r4rrz01y9zmiwjlhcanrs13r1yzp2mycn9q5865";
    };

    # Remove unneccessary circular dependency on buildbot
    postPatch = ''
      sed -i "s/'buildbot'//" setup.py
    '';

    buildInputs = [ buildbot-pkg mock ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
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
      sha256 = "0yh0dpg27gl3pk3nimj1yb6rw7kxvsv1bvzc6hbcfx3a9qdajicj";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
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
      sha256 = "0b9fffr53wfq328csrqgdinafbs1v5s7yn4ky8faw6sqyd8l197v";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
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
      sha256 = "0pz1kmq731ap79l05l13f10r81lzgif5aydpsfz3k5fa9flvxjxs";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
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
      sha256 = "1jf72dzmgwrkqbr2f8s2dvf0zpvl3vbdq0qsf0g8xal272l7cmca";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot WSGI dashboards Plugin";
      maintainers = with maintainers; [ lopsided98 ];
      license = licenses.gpl2;
    };
  };
}
