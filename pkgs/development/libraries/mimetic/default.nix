{ lib, stdenv, fetchurl, fetchpatch, cutee }:

stdenv.mkDerivation rec {
  pname = "mimetic";
  version = "0.9.8";

  src = fetchurl {
    url    = "http://www.codesink.org/download/${pname}-${version}.tar.gz";
    sha256 = "003715lvj4nx23arn1s9ss6hgc2yblkwfy5h94li6pjz2a6xc1rs";
  };

  buildInputs = [ cutee ];

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/m/mimetic/0.9.8-10/debian/patches/g%2B%2B-11.patch";
      sha256 = "sha256-1JW9zPg67BgNsdIjK/jp9j7QMg50eRMz5FsDsbbzBlI=";
    })
  ] ++ lib.optional stdenv.isAarch64 ./narrowing.patch;

  meta = with lib; {
    description = "MIME handling library";
    homepage    = "http://www.codesink.org/mimetic_mime_library.html";
    license     = licenses.mit;
    maintainers = with maintainers; [ leenaars];
    platforms = platforms.linux;
  };
}
