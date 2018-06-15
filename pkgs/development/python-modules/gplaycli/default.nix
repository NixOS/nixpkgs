{ buildPythonPackage, stdenv, libffi, isPy3k, pyasn1, clint, ndg-httpsclient
, protobuf, requests, args, gpapi, pyaxmlparser, fetchFromGitHub
}:

buildPythonPackage rec {
  version = "3.21";
  name = "gplaycli-${version}";

  src = fetchFromGitHub {
    owner = "matlink";
    repo = "gplaycli";
    rev = version;
    sha256 = "1r5nzi9yzswam0866gypjcvv3f1rw13jwx9s49chp8byxy1dyrs2";
  };

 disabled = !isPy3k;

 propagatedBuildInputs = [ libffi pyasn1 clint ndg-httpsclient protobuf requests args gpapi pyaxmlparser ];

  meta = with stdenv.lib; {
    homepage = https://github.com/matlink/gplaycli;
    description = "Google Play Downloader via Command line";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ma27 ];
  };
}
