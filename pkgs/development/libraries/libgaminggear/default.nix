{ stdenv, fetchurl, cmake, pkgconfig, gettext
, gtk2, libcanberra, libnotify, pcre, sqlite, xorg
}:

stdenv.mkDerivation rec {
  pname = "libgaminggear";
  version = "0.15.1";

  src = fetchurl {
    url = "mirror://sourceforge/libgaminggear/${pname}-${version}.tar.bz2";
    sha256 = "0jf5i1iv8j842imgiixbhwcr6qcwa93m27lzr6gb01ri5v35kggz";
  };

  outputs = [ "dev" "out" "bin" ];

  nativeBuildInputs = [ cmake pkgconfig gettext ];

  propagatedBuildInputs = [
    gtk2 libcanberra libnotify pcre sqlite xorg.libXdmcp xorg.libpthreadstubs
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DINSTALL_CMAKE_MODULESDIR=lib/cmake"
    "-DINSTALL_PKGCONFIGDIR=lib/pkgconfig"
    "-DINSTALL_LIBDIR=lib"
  ];

  postFixup = ''
    moveToOutput bin "$bin"
  '';

  meta = {
    description = "Provides functionality for gaming input devices";
    homepage = https://sourceforge.net/projects/libgaminggear/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
