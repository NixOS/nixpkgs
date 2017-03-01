# generated using pypi2nix tool (version: 1.6.0)
#
# COMMAND:
#   pypi2nix -V 2.7 -r requirements.txt
#

{ pkgs, python, commonBuildInputs ? [], commonDoCheck ? false }:

self: {

  "PyQRCode" = python.mkDerivation {
    name = "PyQRCode-1.1";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/9b/2c/ac39412b8661c5ac9b6168b9599e3c42a324901c201efc8e7d4de044c417/PyQRCode-1.1.tar.gz"; sha256 = "a22814bf88c8632ebe496e3300793c12471bb448d3186032445990c44ddcdd51"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."pypng"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "A QR code generator written purely in Python with SVG, EPS, PNG and terminal output.";
    };
  };



  "backports.ssl-match-hostname" = python.mkDerivation {
    name = "backports.ssl-match-hostname-3.4.0.2";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/3a/15/f9e48bfd2b971ade10ad0c03babab057791c260b05322cbd3f47e27be108/backports.ssl_match_hostname-3.4.0.2.tar.gz"; sha256 = "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.psfl;
      description = "The ssl.match_hostname() function from Python 3.4";
    };
  };



  "colorama" = python.mkDerivation {
    name = "colorama-0.3.3";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/24/84/29ce4167d1f5c4a320aaad91e1178e5a1baf9cfe1c63f9077c5dade0e3cc/colorama-0.3.3.tar.gz"; sha256 = "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Cross-platform colored terminal text.";
    };
  };



  "enum34" = python.mkDerivation {
    name = "enum34-1.0.4";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/72/c9/3c640a9cd54a731f3c54d97515b06aae6f6d16a5878a632dbfa9ffe5e663/enum34-1.0.4.tar.gz"; sha256 = "d3c19f26a6a34629c18c775f59dfc5dd595764c722b57a2da56ebfb69b94e447"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Python 3.4 Enum backported to 3.3, 3.2, 3.1, 2.7, 2.6, 2.5, and 2.4";
    };
  };



  "gevent" = python.mkDerivation {
    name = "gevent-1.1.1";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/12/dc/0b2e57823225de86f6e111a65d212c9e3b64847dddaa19691a6cb94b0b2e/gevent-1.1.1.tar.gz"; sha256 = "6ee5b9851b2acde08df7ab9b9a2903f58b4b0e555405c444f4b1dd16f71caeea"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."greenlet"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Coroutine-based network library";
    };
  };



  "gevent-websocket" = python.mkDerivation {
    name = "gevent-websocket-0.9.3";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/0e/18/9e7d900b40a7be1785b27f5fdba0306bcb1b857b1683d34457a2b812dd77/gevent-websocket-0.9.3.tar.gz"; sha256 = "6475220340f9f8895a0f51bd2b9df3511bc7765dc055f49e997584bdaee3381f"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."gevent"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "Copyright 2011-2013 Jeffrey Gelens <jeffrey@noppo.pro>";
      description = "Websocket handler for the gevent pywsgi server, a Python network library";
    };
  };



  "greenlet" = python.mkDerivation {
    name = "greenlet-0.4.12";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/be/76/82af375d98724054b7e273b5d9369346937324f9bcc20980b45b068ef0b0/greenlet-0.4.12.tar.gz"; sha256 = "e4c99c6010a5d153d481fdaf63b8a0782825c0721506d880403a3b9b82ae347e"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Lightweight in-process concurrent programming";
    };
  };



  "httplib2" = python.mkDerivation {
    name = "httplib2-0.9.1";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/38/9c/cd76fde3a74d36a0317422dee019ae5f73ce27e62d817ca003e018d9f9d8/httplib2-0.9.1.tar.gz"; sha256 = "bc6339919a5235b9d1aaee011ca5464184098f0c47c9098001f91c97176583f5"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "A comprehensive HTTP client library.";
    };
  };



  "libpebble2" = python.mkDerivation {
    name = "libpebble2-0.0.26";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/17/1c/0625cca1b3ef9e0c0b9cc2ab5bb5e496e0e43fd3d4f72d1b011158f81346/libpebble2-0.0.26.tar.gz"; sha256 = "5feddc5923fa1cb264054823f004486e63ed80e22dc78528ac681e557b4fc69a"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."enum34"
      self."pyserial"
      self."six"
      self."websocket-client"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Library for communicating with pebbles over pebble protocol";
    };
  };



  "netaddr" = python.mkDerivation {
    name = "netaddr-0.7.18";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/7c/ec/104f193e985e0aa813ffb4ba5da78d6ae3200165bf583d522ac2dc40aab2/netaddr-0.7.18.tar.gz"; sha256 = "a1f5c9fcf75ac2579b9995c843dade33009543c04f218ff7c007b3c81695bd19"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "A network address manipulation library for Python";
    };
  };



  "oauth2client" = python.mkDerivation {
    name = "oauth2client-1.4.12";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/8b/c9/cda58ea5c2f9bbc7c4ed8a15978871a5de51204ee884730739ea7491bce0/oauth2client-1.4.12.tar.gz"; sha256 = "74aa6c3beb90a4a7b9b8d0bc3cd60db34d45c5ee6136187bb9eabe85b4990e5e"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."httplib2"
      self."pyasn1"
      self."pyasn1-modules"
      self."rsa"
      self."six"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.asl20;
      description = "OAuth 2.0 client library";
    };
  };



  "packaging" = python.mkDerivation {
    name = "packaging-16.7";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/28/ad/4e6601d14b11bb300719a8bb6247f6ef5861467a692523c978a4e9e3981a/packaging-16.7.tar.gz"; sha256 = "2e246cde53917a320c4edb549b6b6ed0c80e22be835047bad814687c7345011e"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."pyparsing"
      self."six"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Core utilities for Python packages";
    };
  };



  "peewee" = python.mkDerivation {
    name = "peewee-2.4.7";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/b5/6c/0093f825abca5d1978a5dd1602a1e432710bd6591a24251b4d32dab605af/peewee-2.4.7.tar.gz"; sha256 = "8ad1c4fb202332a969da83a0af712bca96ed6e2a70ca1523ab3d2a2234ed47bd"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "a little orm";
    };
  };



  "progressbar2" = python.mkDerivation {
    name = "progressbar2-2.7.3";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/07/f4/874015e0b682f7e870601f79e1795bcc99a4626054048c1b08a19adef7fd/progressbar2-2.7.3.tar.gz"; sha256 = "8366ffc752ebe3c8e50db2699b7b1dc3cb6ff3750065e965a2591ac50270b794"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.lgpl2;
      description = "Text progress bar library for Python.";
    };
  };



  "pyasn1" = python.mkDerivation {
    name = "pyasn1-0.1.8";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/4d/03/610900771f75708fb8f2c254d67fe3f01db9b8f970da4fc020ce02926a70/pyasn1-0.1.8.tar.gz"; sha256 = "5d33be7ca0ec5997d76d29ea4c33b65c00c0231407fff975199d7f40530b8347"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "ASN.1 types and codecs";
    };
  };



  "pyasn1-modules" = python.mkDerivation {
    name = "pyasn1-modules-0.0.6";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/89/48/3dedf608c53ef0904b7d90328d80d9a3e25fc6509d0e6ae3ca92fe8890b9/pyasn1-modules-0.0.6.tar.gz"; sha256 = "1f41d3f3da43e9a769e23649724368aa0b88afcfd1fe6e9f210d31d13322fc15"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."pyasn1"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "A collection of ASN.1-based protocols modules.";
    };
  };



  "pygeoip" = python.mkDerivation {
    name = "pygeoip-0.3.2";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/ed/65/bb86312b064a6e79c82965202f239850008dbcc9bb24bd0d0bfc7b7bea0b/pygeoip-0.3.2.tar.gz"; sha256 = "f22c4e00ddf1213e0fae36dc60b46ee7c25a6339941ec1a975539014c1f9a96d"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "LGPLv3+";
      description = "Pure Python GeoIP API";
    };
  };



  "pyparsing" = python.mkDerivation {
    name = "pyparsing-2.1.10";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/38/bb/bf325351dd8ab6eb3c3b7c07c3978f38b2103e2ab48d59726916907cd6fb/pyparsing-2.1.10.tar.gz"; sha256 = "811c3e7b0031021137fc83e051795025fcb98674d07eb8fe922ba4de53d39188"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Python parsing module";
    };
  };



  "pypkjs" = python.mkDerivation {
    name = "pypkjs-1.0.6";
    src = pkgs.fetchurl { url = "https://s3-us-west-2.amazonaws.com/pebble-sdk-homebrew/pypkjs-1.0.6.tar.gz"; sha256 = "43a05fb007a65cf81f68505e94679fc21d3d31e79e17df9a1bc086ad7da9b0f3"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."backports.ssl-match-hostname"
      self."gevent"
      self."gevent-websocket"
      self."greenlet"
      self."libpebble2"
      self."netaddr"
      self."peewee"
      self."pygeoip"
      self."pypng"
      self."python-dateutil"
      self."requests"
      self."sh"
      self."six"
      self."websocket-client"
      self."wsgiref"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "A Pebble phone app simulator written in Python";
    };
  };



  "pypng" = python.mkDerivation {
    name = "pypng-0.0.17";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/c5/82/69dfce987e1b716a21050885b0a065824ba9825a7e7bc660f1aaff319eb0/pypng-0.0.17.tar.gz"; sha256 = "2dfa74ac28a4c41ae61e62d243410548c7c174bd990528d30270324f15211544"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Pure Python PNG image encoder/decoder";
    };
  };



  "pyserial" = python.mkDerivation {
    name = "pyserial-2.7";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/df/c9/d9da7fafaf2a2b323d20eee050503ab08237c16b0119c7bbf1597d53f793/pyserial-2.7.tar.gz"; sha256 = "3542ec0838793e61d6224e27ff05e8ce4ba5a5c5cc4ec5c6a3e8d49247985477"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.psfl;
      description = "Python Serial Port Extension";
    };
  };



  "python-dateutil" = python.mkDerivation {
    name = "python-dateutil-2.4.1";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/62/fe/45044dfa6bfa6ff18ddfe1df85fbf01d333c284b94e8c9a02fe12241c8cf/python-dateutil-2.4.1.tar.bz2"; sha256 = "a9f62b12e28f11c732ad8e255721a9c7ab905f9479759491bc1f1e91de548d0f"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."six"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Extensions to the standard Python datetime module";
    };
  };



  "requests" = python.mkDerivation {
    name = "requests-2.7.0";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/0a/00/8cc925deac3a87046a4148d7846b571cf433515872b5430de4cd9dea83cb/requests-2.7.0.tar.gz"; sha256 = "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."pyasn1"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.asl20;
      description = "Python HTTP for Humans.";
    };
  };



  "rsa" = python.mkDerivation {
    name = "rsa-3.1.4";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/db/65/01448b2f3e222a846cbe7a62ea61950c5659b1f9489171eb68242415f92c/rsa-3.1.4.tar.gz"; sha256 = "e2b0b05936c276b1edd2e1525553233b666df9e29b5c3ba223eed738277c82a0"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."pyasn1"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "License :: OSI Approved :: Apache Software License";
      description = "Pure-Python RSA implementation";
    };
  };



  "sh" = python.mkDerivation {
    name = "sh-1.9";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/30/3a/b1d17c1a52627d008b5667da41d65d13969447fa2e77f8a0d349866c0210/sh-1.09.tar.gz"; sha256 = "f3d174e2ad25c39f28935bae672be51aa083063d3122405ceeb2a3e7a8239d45"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Python subprocess interface";
    };
  };



  "six" = python.mkDerivation {
    name = "six-1.9.0";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/16/64/1dc5e5976b17466fd7d712e59cbe9fb1e18bec153109e5ba3ed6c9102f1a/six-1.9.0.tar.gz"; sha256 = "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Python 2 and 3 compatibility utilities";
    };
  };



  "virtualenv" = python.mkDerivation {
    name = "virtualenv-13.1.0";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/6e/48/4d57ca13ffb07b6a844215c11c43a0b96c35ebf4e8ad238ec0611582b15f/virtualenv-13.1.0.tar.gz"; sha256 = "7ef0a0b1a1cb4b6407d2c1ff4a0f74865a13e6219482888a21bdcaa60c0f1e73"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Virtual Python Environment builder";
    };
  };



  "websocket-client" = python.mkDerivation {
    name = "websocket-client-0.32.0";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/f4/06/5552e64fee863aa9decbb4e46dccc05fe730a36f49f0d6427398837297da/websocket_client-0.32.0.tar.gz"; sha256 = "cb3ab95617ed2098d24723e3ad04ed06c4fde661400b96daa1859af965bfe040"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      self."six"
    ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = licenses.lgpl2;
      description = "WebSocket client for python. hybi13 is supported.";
    };
  };



  "wsgiref" = python.mkDerivation {
    name = "wsgiref-0.1.2";
    src = pkgs.fetchurl { url = "https://pypi.python.org/packages/41/9e/309259ce8dff8c596e8c26df86dbc4e848b9249fd36797fd60be456f03fc/wsgiref-0.1.2.zip"; sha256 = "c7e610c800957046c04c8014aab8cce8f0b9f0495c8cd349e57c1f7cabf40e79"; };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with pkgs.stdenv.lib; {
      homepage = "";
      license = "PSF or ZPL";
      description = "WSGI (PEP 333) Reference Library";
    };
  };

}
