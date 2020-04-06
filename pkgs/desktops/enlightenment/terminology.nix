{ stdenv, fetchurl, meson, ninja, pkgconfig, efl, pcre, mesa, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "terminology";
  version = "1.6.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0xxx4xyhis6fy3frgb34ip0aj0kc4zashf60gzbxmq5gadbb0p5r";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    makeWrapper
  ];

  buildInputs = [
    efl
    pcre
    mesa
  ];

  meta = {
    description = "Powerful terminal emulator based on EFL";
    homepage = https://www.enlightenment.org/about-terminology;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx romildo ];
  };
}
