{ stdenv
, lib
, fetchurl
, fetchpatch
, perlPackages
, intltool
, autoreconfHook
, pkg-config
, glib
, libxml2
, sqlite
, zlib
, sg3_utils
, gdk-pixbuf
, taglib
, libimobiledevice
, monoSupport ? false
, mono
, gtk-sharp-2_0
}:

stdenv.mkDerivation rec {
  pname = "libgpod";
  version = "0.8.3";

  src = fetchurl {
    url = "mirror://sourceforge/gtkpod/libgpod-${version}.tar.bz2";
    hash = "sha256-Y4p5WdBOlfHmKrrQK9M3AuTo3++YSFrH2dUDlcN+lV0=";
  };

  outputs = [ "out" "dev" ];

  patches = [
    (fetchpatch {
      name = "libplist-2.3.0-compatibility.patch";
      url = "https://sourceforge.net/p/gtkpod/patches/48/attachment/libplist-2.3.0-compatibility.patch";
      hash = "sha256-aVkuYE1N/jdEhVhiXEVhApvOC+8csIMMpP20rAJwEVQ=";
    })
  ];

  postPatch = ''
    # support libplist 2.2
    substituteInPlace configure.ac --replace 'libplist >= 1.0' 'libplist-2.0 >= 2.2'
  '';

  configureFlags = [
    "--without-hal"
    "--enable-udev"
    "--with-udev-dir=${placeholder "out"}/lib/udev"
  ] ++ lib.optionals monoSupport [ "--with-mono" ];

  dontStrip = monoSupport;

  nativeBuildInputs = [ autoreconfHook intltool pkg-config ]
    ++ (with perlPackages; [ perl XMLParser ])
    ++ lib.optional monoSupport mono;

  buildInputs = [
    libxml2
    sg3_utils
    sqlite
    taglib
  ] ++ lib.optional monoSupport gtk-sharp-2_0;

  propagatedBuildInputs = [
    gdk-pixbuf
    glib
    libimobiledevice
  ];

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/gtkpod/";
    description = "Library used by gtkpod to access the contents of an ipod";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
