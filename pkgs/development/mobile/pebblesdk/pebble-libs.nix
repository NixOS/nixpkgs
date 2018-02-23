{ lib, fetchurl, python27 }:

with python27.pkgs;

rec {
  libpebble2 = buildPythonPackage rec {
    pname = "libpebble2";
    version = "0.0.26";
    src = fetchPypi {
      inherit pname version;
      sha256 = "16n69xxma7k8mhl8birdwa0fsqvf902g08s80mjb477s4dcxrvaz";
    };

    # The libpebble distribution on pypi doesn't include tests.
    doCheck = false;

    propagatedBuildInputs = [ enum34 pyserial six websocket_client ];

    meta = with lib; {
      homepage = https://github.com/pebble/libpebble2;
      license = licenses.mit;
      description = "Library for communicating with pebbles over pebble protocol";
    };
  };

  pypkjs = buildPythonPackage {
    pname = "pypkjs";
    version = "1.0.6";
    src = fetchurl {
      url = "https://s3-us-west-2.amazonaws.com/pebble-sdk-homebrew/pypkjs-1.0.6.tar.gz";
      sha256 = "43a05fb007a65cf81f68505e94679fc21d3d31e79e17df9a1bc086ad7da9b0f3";
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

    meta = with lib; {
      homepage = "";
      license = licenses.mit;
      description = "A Pebble phone app simulator written in Python";
    };
  };

  # progressbar2 version 3 has incompatible changes, so use an old version here
  progressbar2 = buildPythonPackage rec {
    pname = "progressbar2";
    version = "2.7.3";

    src = fetchPypi {
      inherit pname version;
      sha256 = "155pf01ca6jrl9jyjr80fprnzjy33mxrnsdj1pjwiqzbab3zyrl3";
    };

    nativeBuildInputs = [ pytestrunner ];

    meta = with stdenv.lib; {
      homepage = https://progressbar-2.readthedocs.io/en/latest/;
      description = "Text progressbar library for python";
      license = licenses.bsd3;
    };
  };
}
