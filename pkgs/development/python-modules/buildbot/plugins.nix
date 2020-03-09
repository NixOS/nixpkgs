{ lib, buildPythonPackage, fetchPypi, buildbot-pkg, mock }:

{
  www = buildPythonPackage rec {
    pname = "buildbot-www";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "1d8xdk4rq4p3fw03cvz7d1pmpjjbyrnzzjifzv46q88vk7jakgxi";
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
      sha256 = "03pl75avi6cmmhjvfn0a0b4drn35yv37kvgn04zjdwa3m6p3haa8";
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
      sha256 = "0rzjk3qmlvid8qag3r00zaszchncl1nl8l2yapvc1zqh2dqlln58";
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
      sha256 = "1n4j73y9kwfqk7dz1fh1bpan68vlpnbz7idxpmsphyay8w8y9dd4";
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
      sha256 = "1babkcgxczs6zfk2b6jmsy2vwbrgdydrp2px1mfwa3wmv8fwlssg";
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
