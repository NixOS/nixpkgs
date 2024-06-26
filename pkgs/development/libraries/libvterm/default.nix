{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "libvterm";
  version = "0.99.7";

  src = fetchurl {
    url = "mirror://sourceforge/libvterm/${pname}-${version}.tar.gz";
    sha256 = "10gaqygmmwp0cwk3j8qflri5caf8vl3f7pwfl2svw5whv8wkn0k2";
  };

  preInstall = ''
    mkdir -p $out/include $out/lib
  '';

  postPatch = ''
    substituteInPlace Makefile \
      --replace "gcc" "${stdenv.cc.targetPrefix}cc" \
      --replace "ldconfig" "" \
      --replace "/usr" "$out"

    makeFlagsArray+=("PKG_CFG=`${stdenv.cc.targetPrefix}pkg-config --cflags glib-2.0`")
  '';

  # For headers
  propagatedBuildInputs = [ glib ];

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses ];

  meta = with lib; {
    homepage = "http://libvterm.sourceforge.net/";
    description = "Terminal emulator library to mimic both vt100 and rxvt";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
