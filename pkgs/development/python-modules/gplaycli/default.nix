{ buildPythonPackage, lib, libffi, isPy3k, pyasn1, clint, ndg-httpsclient
, protobuf, requests, args, matlink-gpapi, pyaxmlparser, setuptools, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "gplaycli";
  version = "3.29";

  src = fetchFromGitHub {
    owner = "matlink";
    repo = "gplaycli";
    rev = version;
    sha256 = "10gc1wr259z5hxyk834wyyggvyh82agfq0zp711s4jf334inp45r";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ libffi pyasn1 clint ndg-httpsclient protobuf requests args matlink-gpapi pyaxmlparser setuptools ];

  meta = with lib; {
    homepage = "https://github.com/matlink/gplaycli";
    description = "Google Play Downloader via Command line";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
