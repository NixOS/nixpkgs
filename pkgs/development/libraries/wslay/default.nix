{ stdenv, lib, fetchurl, cunit }:

stdenv.mkDerivation rec {
  pname = "wslay";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/tatsuhiro-t/wslay/releases/download/release-${version}/wslay-${version}.tar.gz";
    hash = "sha256-kM5oxt/WFHItRPuxRWOj9trMaLVIsgrjgqxPSVLFUmg=";
  };

  checkInputs = [ cunit ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://tatsuhiro-t.github.io/wslay/";
    description = "The WebSocket library in C";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ pingiun ];
    platforms = platforms.unix;
  };
}
