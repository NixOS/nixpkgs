{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  libx11,
  makeWrapper,
  tcl,
  tk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vkeybd";
  version = "0.1.18d";

  src = fetchurl {
    url = "ftp://ftp.suse.com/pub/people/tiwai/vkeybd/vkeybd-${finalAttrs.version}.tar.bz2";
    sha256 = "0107b5j1gf7dwp7qb4w2snj4bqiyps53d66qzl2rwj4jfpakws5a";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    alsa-lib
    libx11
    tcl
    tk
  ];

  configurePhase = ''
    runHook preConfigure

    mkdir -p $out/bin
    sed -e "s@/usr/local@$out@" -i Makefile

    runHook postConfigure
  '';

  makeFlags = [
    "TKLIB=-l${tk.libPrefix}"
    "TCLLIB=-l${tcl.libPrefix}"
  ];

  meta = {
    description = "Virtual MIDI keyboard";
    homepage = "https://www.alsa-project.org/~tiwai/alsa.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
