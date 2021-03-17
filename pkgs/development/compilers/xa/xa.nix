{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "xa";
  version = "2.3.11";

  src = fetchurl {
    url = "https://www.floodgap.com/retrotech/xa/dists/${pname}-${version}.tar.gz";
    hash = "sha256-MvIWTJnjBSGOmSlwhW3Y4jCbXLasR1jXsq/jv+vJAS0=";
  };

  dontConfigure = true;

  postPatch = ''
    substitueInPlace \
      --replace "DESTDIR" "PREFIX" \
      --replace "CC = gcc" "CC = cc" \
      --replace "LDD = gcc" "LDD = ld" \
      --replace "CFLAGS = -O2" "CFLAGS ?=" \
      --replace "LDFLAGS = -lc" "LDFLAGS ?= -lc" \
      Makefile
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://www.floodgap.com/retrotech/xa/";
    description = "Andre Fachat's open-source 6502 cross assembler";
    longDescription = ''
      xa is a high-speed, two-pass portable cross-assembler. It understands
      mnemonics and generates code for NMOS 6502s (such as 6502A, 6504, 6507,
      6510, 7501, 8500, 8501, 8502 ...), CMOS 6502s (65C02 and Rockwell R65C02)
      and the 65816.

      Key amongst its features:

      - C-like preprocessor (and understands cpp for additional feature support)
      - rich expression syntax and pseudo-op vocabulary
      - multiple character sets
      - binary linking
      - supports o65 relocatable objects with a full linker and relocation
        suite, as well as "bare" plain binary object files
      - block structure for label scoping
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
