{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libffcall";
  version = "2.4";

  src = fetchurl {
    url = "mirror://gnu/libffcall/libffcall-${version}.tar.gz";
    sha256 = "sha256-jvaZIdvcBrxbuQUTYiY3p7g6cfMfW6N3vp2P2PV5EsI=";
  };

  enableParallelBuilding = false;

  outputs = [ "dev" "out" "doc" "man" ];

  postInstall = ''
    mkdir -p $doc/share/doc/libffcall
    mv $out/share/html $doc/share/doc/libffcall
    rm -rf $out/share
  '';

  meta = with lib; {
    description = "Foreign function call library";
    homepage = "https://www.gnu.org/software/libffcall/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
