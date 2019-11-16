{ stdenv, fetchurl, meson, ninja, pkgconfig, efl, pcre, mesa, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "terminology";
  version = "1.5.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0v4amfg8ji0mb6j7kcxh3wz1xw5zyxg4rw6ylx17rfw2nc1yamfy";
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
