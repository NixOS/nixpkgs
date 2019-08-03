{ stdenv, fetchurl, meson, ninja, pkgconfig, efl, pcre, mesa, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "terminology";
  version = "1.4.1";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0mm9v5a94369is3kaarnr3a28wy42wslzi1mcisaidlcldgv7f6p";
  };

  nativeBuildInputs = [
    meson
    ninja
    (pkgconfig.override { vanilla = true; })
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
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
  };
}
