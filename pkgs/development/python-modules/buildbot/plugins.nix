{ lib, buildPythonPackage, fetchPypi, buildbot-pkg, mock }:

{
  www = buildPythonPackage rec {
    pname = "buildbot-www";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-boa/MWi/HAhNU3/n96i0fuoQ+jT5I+dWoe1Zd7f/Yvs=";
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
      maintainers = with maintainers; [ ryansydnor lopsided98 ];
      license = licenses.gpl2;
    };
  };

  console-view = buildPythonPackage rec {
    pname = "buildbot-console-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-NUDTwgkQuasOlJxNTlvfIm99LNVCrRIdBmgeJnwkSU8=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Console View Plugin";
      maintainers = with maintainers; [ ryansydnor lopsided98 ];
      license = licenses.gpl2;
    };
  };

  waterfall-view = buildPythonPackage rec {
    pname = "buildbot-waterfall-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-EmiIDCG4iFIwFnwii8fjII7C7wsBifzeZeW7HyY04dE=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Waterfall View Plugin";
      maintainers = with maintainers; [ ryansydnor lopsided98 ];
      license = licenses.gpl2;
    };
  };

  grid-view = buildPythonPackage rec {
    pname = "buildbot-grid-view";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-QcS8QJ17uzDvkynTczj05LojuIT6feGiQNCwCESbVLw=";
    };

    buildInputs = [ buildbot-pkg ];

    # No tests
    doCheck = false;

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot Grid View Plugin";
      maintainers = with maintainers; [ lopsided98 ];
      license = licenses.gpl2;
    };
  };

  wsgi-dashboards = buildPythonPackage rec {
    pname = "buildbot-wsgi-dashboards";
    inherit (buildbot-pkg) version;

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-U9ecRxpDowzjD4GsrW4FUHcbNaWeAFGKDlqMrbIoTrQ=";
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
