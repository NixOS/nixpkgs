{ lib
, stdenv
, fetchurl
, freetype
, fontconfig
, libICE
, libX11
, libXp
, libXau
, libXext
, libXt
}:

stdenv.mkDerivation rec {
  pname = "lesstif";
  version = "0.95.2";
  src = fetchurl {
    url = "mirror://sourceforge/lesstif/${pname}-${version}.tar.bz2";
    sha256 = "1qzpxjjf7ri1jzv71mvq5m9g8hfaj5yzwp30rwxlm6n2b24a6jpb";
  };
  buildInputs = [
    freetype
    fontconfig
    libICE
    libX11
    libXext
    libXt
  ];
  propagatedBuildInputs = [
    libXau
    libXp
  ];

  # These patches fix a number of later issues - in particular the
  # render_table_crash shows up in 'arb'. The same patches appear
  # in Debian, so we assume they have been sent upstream.
  #
  patches = [
    ./c-missing_xm_h.patch
    ./c-render_table_crash.patch
    ./c-xpmpipethrough.patch
    ];

  meta = with lib; {
    description = "An open source clone of the Motif widget set";
    homepage = "https://lesstif.sourceforge.net";
    platforms = platforms.unix;
    license = with licenses; [ gpl2 lgpl2 ];
  };
}
