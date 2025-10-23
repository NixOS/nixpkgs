{
  stdenv,
  fetchurl,
  lib,
  pkg-config,
  glib,
  gtk2,
  libticonv,
  libtifiles2,
  libticables2,
  libticalcs2,
}:

stdenv.mkDerivation rec {
  pname = "tilem";
  version = "2.0";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1ba38xzhp3yf21ip3cgql6jzy49jc34sfnjsl4syxyrd81d269zw";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    gtk2
    libticonv
    libtifiles2
    libticables2
    libticalcs2
  ];
  patches = [ ./gcc14-fix.patch ];
  env.NIX_CFLAGS_COMPILE = toString [ "-lm" ];
  meta = with lib; {
    homepage = "http://lpg.ticalc.org/prj_tilem/";
    description = "Emulator and debugger for Texas Instruments Z80-based graphing calculators";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "tilem2";
  };
}
