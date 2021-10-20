{ lib, stdenv, fetchurl, cutee }:

stdenv.mkDerivation rec {
  pname = "mimetic";
  version = "0.9.8";

  src = fetchurl {
    url    = "http://www.codesink.org/download/${pname}-${version}.tar.gz";
    sha256 = "003715lvj4nx23arn1s9ss6hgc2yblkwfy5h94li6pjz2a6xc1rs";
  };

  buildInputs = [ cutee ];

  patches = lib.optional stdenv.isAarch64 ./narrowing.patch;

  meta = with lib; {
    description = "MIME handling library";
    homepage    = "http://www.codesink.org/mimetic_mime_library.html";
    license     = licenses.mit;
    maintainers = with maintainers; [ leenaars];
    platforms = platforms.linux;
  };
}
