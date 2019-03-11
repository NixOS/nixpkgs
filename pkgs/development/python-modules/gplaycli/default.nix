{ buildPythonPackage, stdenv, libffi, isPy3k, pyasn1, clint, ndg-httpsclient
, protobuf, requests, args, gpapi, pyaxmlparser, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "gplaycli";
  version = "3.25";

  src = fetchFromGitHub {
    owner = "matlink";
    repo = "gplaycli";
    rev = version;
    sha256 = "1rygx5cg4b1vwpkiaq6jcpbc1ly7cspslv3sy7x8n8ba61ryq6h4";
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
