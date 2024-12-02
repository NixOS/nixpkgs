{ lib, stdenv, fetchurl, tcl, tk }:

stdenv.mkDerivation rec {
  pname = "tkrev";
  version = "9.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/tkcvs/tkrev_${version}.tar.gz";
    sha256 = "sha256-WHDZPShEB9Q+Bjbb37mogJLUZk2GuWoO8bz+Zydc7i4=";
  };

  buildInputs = [ tcl tk ];

  patchPhase = ''
    for file in tkrev/tkrev.tcl tkdiff/tkdiff; do
        substituteInPlace "$file" \
            --replace "exec wish" "exec ${tk}/bin/wish"
    done
  '';

  installPhase = ''
    ./doinstall.tcl $out
  '';

  meta = {
    homepage = "https://tkcvs.sourceforge.io";
    description = "TCL/TK GUI for cvs and subversion";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
