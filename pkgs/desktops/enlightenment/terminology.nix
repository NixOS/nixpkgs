{ stdenv, fetchurl, meson, ninja, pkgconfig, efl, pcre, mesa_noglu, makeWrapper }:

stdenv.mkDerivation rec {
  name = "terminology-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/terminology/${name}.tar.xz";
    sha256 = "1ii8332bl88l8md3gvz5dhi9bjpm6shyf14ck9kfyy7d56hp71mc";
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
