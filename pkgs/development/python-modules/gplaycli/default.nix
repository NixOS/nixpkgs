{ buildPythonPackage, stdenv, libffi, isPy3k, pyasn1, clint, ndg-httpsclient
, protobuf, requests, args, gpapi, pyaxmlparser, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "gplaycli";
  version = "3.26";

  src = fetchFromGitHub {
    owner = "matlink";
    repo = "gplaycli";
    rev = version;
    sha256 = "188237d40q35dp5xs7hg4ybhvsyxi0bsqx5dk4ws9007n596in5f";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ libffi pyasn1 clint ndg-httpsclient protobuf requests args gpapi pyaxmlparser ];

  meta = with stdenv.lib; {
    homepage = https://github.com/matlink/gplaycli;
    description = "Google Play Downloader via Command line";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
