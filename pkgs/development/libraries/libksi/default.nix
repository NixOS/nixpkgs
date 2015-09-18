{ stdenv, fetchFromGitHub, autoreconfHook, openssl, curl }:

stdenv.mkDerivation rec {
  name = "libksi-2015-07-03";

  src = fetchFromGitHub {
    owner = "rgerhards";
    repo = "libksi";
    rev = "b1ac0346395b4f52ec42a050bf33ac223f194443";
    sha256 = "0gg0fl56flwqmsph7j92lgybaa39i715w0nwgkcr58njm0c02wlw";
  };
  
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl curl ];

  configureFlags = [
    "--with-openssl=${openssl}"
    "--with-cafile=/etc/ssl/certs/ca-certificates.crt"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/rgerhards/libksi";
    description = "Keyless Signature Infrastructure API library";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
