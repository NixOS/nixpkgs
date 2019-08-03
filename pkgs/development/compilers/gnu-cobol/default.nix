{ stdenv, fetchurl, gcc, makeWrapper
, db, gmp, ncurses }:

let
  version = "2.2";
  lib = stdenv.lib;
in
stdenv.mkDerivation rec {
  name = "gnu-cobol-${version}";
  inherit version;

  src = fetchurl {
    url = "https://sourceforge.com/projects/open-cobol/files/gnu-cobol/${version}/gnucobol-${version}.tar.gz";
    sha256 = "1jrjmdx0swssjh388pp08awhiisbrs2i7gx4lcm4p1k5rpg3hn4j";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ db gmp ncurses ];

  cflags  = stdenv.lib.concatMapStringsSep " " (p: "-L" + (lib.getLib p) + "/lib ") buildInputs;
  ldflags = stdenv.lib.concatMapStringsSep " " (p: "-I" + (lib.getDev p) + "/include ") buildInputs;

  cobolCCFlags = "-I$out/include ${ldflags} -L$out/lib ${cflags}";

  postInstall = with stdenv.lib; ''
    wrapProgram "$out/bin/cobc" \
      --set COB_CC "${gcc}/bin/gcc" \
      --prefix COB_LDFLAGS " " "${cobolCCFlags}" \
      --prefix COB_CFLAGS " " "${cobolCCFlags}"
  '';

  meta = with stdenv.lib; {
    description = "An open-source COBOL compiler";
    homepage = https://sourceforge.net/projects/open-cobol/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ericsagnes the-kenny ];
    platforms = with platforms; linux ++ darwin;
  };
}
