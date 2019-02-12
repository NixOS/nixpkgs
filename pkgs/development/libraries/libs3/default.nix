{ stdenv, fetchFromGitHub, curl, libxml2 }:

stdenv.mkDerivation {
  name = "libs3-2018-12-03";

  src = fetchFromGitHub {
    owner = "bji";
    repo = "libs3";
    rev = "111dc30029f64bbf82031f3e160f253a0a63c119";
    sha256 = "1ahf08hc7ql3fazfmlyj9vrhq7cvarsmgn2v8149y63zr1fl61hs";
  };

  buildInputs = [ curl libxml2 ];

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/bji/libs3;
    description = "A library for interfacing with amazon s3";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
  };
}
