{ stdenv, lib, fetchurl, perlPackages, intltool, autoreconfHook,
  pkg-config, glib, libxml2, sqlite, zlib, sg3_utils, gdk-pixbuf, taglib,
  libimobiledevice,
  monoSupport ? false, mono, gtk-sharp-2_0
}:


stdenv.mkDerivation rec {
  name = "libgpod-0.8.3";

  src = fetchurl {
    url = "mirror://sourceforge/gtkpod/${name}.tar.bz2";
    sha256 = "0pcmgv1ra0ymv73mlj4qxzgyir026z9jpl5s5bkg35afs1cpk2k3";
  };

  outputs = [ "out" "dev" ];

  postPatch = ''
    # support libplist 2.2
    substituteInPlace configure.ac --replace 'libplist >= 1.0' 'libplist-2.0 >= 2.2'
  '';

  configureFlags = [
    "--without-hal"
    "--enable-udev"
    "--with-udev-dir=${placeholder "out"}/lib/udev"
  ] ++ lib.optionals monoSupport [ "--with-mono" ];

  dontStrip = true;

  propagatedBuildInputs = [ glib libxml2 sqlite zlib sg3_utils
    gdk-pixbuf taglib libimobiledevice ];

  nativeBuildInputs = [ autoreconfHook intltool pkg-config ]
    ++ (with perlPackages; [ perl XMLParser ])
    ++ lib.optionals monoSupport [ mono gtk-sharp-2_0 ];

  meta = {
    homepage = "https://gtkpod.sourceforge.net/";
    description = "Library used by gtkpod to access the contents of an ipod";
    license = "LGPL";
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
    maintainers = [ ];
  };
}
