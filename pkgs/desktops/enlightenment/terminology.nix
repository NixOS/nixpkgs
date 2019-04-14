{ stdenv, fetchurl, meson, ninja, pkgconfig, efl, pcre, mesa_noglu, makeWrapper }:

stdenv.mkDerivation rec {
  name = "terminology-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/terminology/${name}.tar.xz";
    sha256 = "0q1y7fadj42n23aspx9y8hm4w4xlc316wc3415wnf75ibsx08ngd";
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
