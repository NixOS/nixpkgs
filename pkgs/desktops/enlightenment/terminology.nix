{ stdenv, fetchurl, meson, ninja, pkgconfig, efl, pcre, mesa_noglu, makeWrapper }:

stdenv.mkDerivation rec {
  name = "terminology-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/terminology/${name}.tar.xz";
    sha256 = "07vw28inkimi9avp16j0rqcfqjq16081554qsv29pcqhz18xp59r";
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
    mesa_noglu
  ];

  meta = {
    description = "Powerful terminal emulator based on EFL";
    homepage = https://www.enlightenment.org/about-terminology;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
  };
}
