{ lib, stdenv, fetchurl, gcc, makeWrapper
, db, gmp, ncurses }:

stdenv.mkDerivation rec {
  pname = "gnu-cobol";
  version = "3.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/gnucobol/${lib.versions.majorMinor version}/gnucobol-${version}.tar.xz";
    sha256 = "0x15ybfm63g7c9340fc6712h9v59spnbyaz4rf85pmnp3zbhaw2r";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ db gmp ncurses ];

  cflags  = lib.concatMapStringsSep " " (p: "-L" + (lib.getLib p) + "/lib ") buildInputs;
  ldflags = lib.concatMapStringsSep " " (p: "-I" + (lib.getDev p) + "/include ") buildInputs;

  cobolCCFlags = "-I$out/include ${ldflags} -L$out/lib ${cflags}";

  postInstall = with lib; ''
    wrapProgram "$out/bin/cobc" \
      --set COB_CC "${gcc}/bin/gcc" \
      --prefix COB_LDFLAGS " " "${cobolCCFlags}" \
      --prefix COB_CFLAGS " " "${cobolCCFlags}"
  '';

  meta = with lib; {
    description = "An open-source COBOL compiler";
    homepage = "https://sourceforge.net/projects/gnucobol/";
    license = with licenses; [ gpl3Only lgpl3Only ];
    maintainers = with maintainers; [ ericsagnes ];
    platforms = platforms.all;
  };
}
