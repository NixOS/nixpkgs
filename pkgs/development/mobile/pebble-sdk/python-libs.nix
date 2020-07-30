{ lib, fetchurl, python27 }:

with python27.pkgs; rec {
  gevent = buildPythonPackage rec {
    pname = "gevent";
    version = "1.1.1";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1smf3kvidpdiyi2c81alal74p2zm0clrm6xbyy6y1k9a3f2vkrbf";
    };

    doCheck = false;

    propagatedBuildInputs = [
      greenlet
    ];
  };

  gevent-websocket = buildPythonPackage rec {
    pname = "gevent-websocket";
    version = "0.9.3";
    src = fetchPypi {
      inherit pname version;
      sha256 = "07rqwfpbv13mk6gg8mf0bmvcf6siyffjpgai1xd8ky7r801j4xb4";
    };

    propagatedBuildInputs = [
      gevent
      greenlet
    ];
  };

  libpebble2 = buildPythonPackage rec {
    pname = "libpebble2";
    version = "0.0.26";
    src = fetchPypi {
      inherit pname version;
      sha256 = "16n69xxma7k8mhl8birdwa0fsqvf902g08s80mjb477s4dcxrvaz";
    };

    doCheck = false;

    propagatedBuildInputs = [
      enum34
      pyserial
      six
      websocket_client
    ];
  };

  peewee = buildPythonPackage rec {
    pname = "peewee";
    version = "2.4.7";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1ga7xls24aixmciibjkh59pfv5na5dqsz843v9lsjci343xw9lca";
    };

    doCheck = false;
  };

  progressbar2 = buildPythonPackage rec {
    pname = "progressbar2";
    version = "2.7.3";
    src = fetchPypi {
      inherit pname version;
      sha256 = "155pf01ca6jrl9jyjr80fprnzjy33mxrnsdj1pjwiqzbab3zyrl3";
    };

    nativeBuildInputs = [ pytestrunner ];
  };

  pypkjs = buildPythonPackage rec {
    pname = "pypkjs";
    version = "1.0.6";
    src = fetchurl {
      url = https://s3-us-west-2.amazonaws.com/pebble-sdk-homebrew/pypkjs-1.0.6.tar.gz;
      sha256 = "1wxhm5ysv1n03fddy5wywwqks7f2kxkr8pjhd0gzhp560yq5z823";
    };

    propagatedBuildInputs = [
      gevent
      gevent-websocket
      greenlet
      libpebble2
      netaddr
      peewee
      pygeoip
      pypng
      dateutil
      requests
      sh
      six
      websocket_client
      wsgiref
    ];

    prePatch = ''
      substituteInPlace requirements.txt --replace "==" ">="
    '';
  };

  pypng = buildPythonPackage rec {
    pname = "pypng";
    version = "0.0.20";
    src = fetchPypi {
      inherit pname version;
      sha256 = "02qpa22ls41vwsrzw9r9qhj1nhq05p03hb5473pay6y980s86chh";
    };
  };

  wsgiref = buildPythonPackage rec {
    pname = "wsgiref";
    version = "0.1.2";
    src = fetchPypi {
      inherit pname version;
      extension = "zip";
      sha256 = "0y8fyjmpq7vwwm4x732w97qbkw78rjwal5409k04cw4m03411rn7";
    };
  };
}
