{ pkgs, python27Packages }:

rec {
  libpebble2 = python27Packages.buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "libpebble2";
    version = "0.0.26";
    src = python27Packages.fetchPypi {
      inherit pname version;
      sha256 = "16n69xxma7k8mhl8birdwa0fsqvf902g08s80mjb477s4dcxrvaz";
    };

    # Tries and fails to pull in pytest-mock
    doCheck = false;

    propagatedBuildInputs = with python27Packages; [ enum34 pyserial six websocket_client ];

    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Library for communicating with pebbles over pebble protocol";
    };
  };

  pypkjs = python27Packages.buildPythonPackage {
    name = "pypkjs-1.0.6";
    src = pkgs.fetchurl {
      url = "https://s3-us-west-2.amazonaws.com/pebble-sdk-homebrew/pypkjs-1.0.6.tar.gz";
      sha256 = "43a05fb007a65cf81f68505e94679fc21d3d31e79e17df9a1bc086ad7da9b0f3";
    };

    propagatedBuildInputs = with python27Packages; [
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

    patchPhase = ''
      substituteInPlace requirements.txt --replace "==" ">="
    '';

    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "A Pebble phone app simulator written in Python";
    };
  };
}
