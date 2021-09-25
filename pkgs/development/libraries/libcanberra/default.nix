{ stdenv, lib, fetchurl, fetchpatch, pkg-config, libtool
, gtk2-x11, gtk3-x11 , gtkSupport ? null
, libpulseaudio, gst_all_1, libvorbis, libcap
, Carbon, CoreServices
, withAlsa ? stdenv.isLinux, alsa-lib }:

stdenv.mkDerivation rec {
  pname = "libcanberra";
  version = "0.30";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/libcanberra/${pname}-${version}.tar.xz";
    sha256 = "0wps39h8rx2b00vyvkia5j40fkak3dpipp1kzilqla0cgvk73dn2";
  };

  nativeBuildInputs = [ pkg-config libtool ];
  buildInputs = [
    libpulseaudio libvorbis
  ] ++ (with gst_all_1; [ gstreamer gst-plugins-base ])
    ++ lib.optional (gtkSupport == "gtk2") gtk2-x11
    ++ lib.optional (gtkSupport == "gtk3") gtk3-x11
    ++ lib.optionals stdenv.isDarwin [Carbon CoreServices]
    ++ lib.optional stdenv.isLinux libcap
    ++ lib.optional withAlsa alsa-lib;

  configureFlags = [ "--disable-oss" ];

  patches = [
    (fetchpatch {
      name = "0001-gtk-Don-t-assume-all-GdkDisplays-are-GdkX11Displays-.patch";
      url = "http://git.0pointer.net/libcanberra.git/patch/?id=c0620e432650e81062c1967cc669829dbd29b310";
      sha256 = "0rc7zwn39yxzxp37qh329g7375r5ywcqcaak8ryd0dgvg8m5hcx9";
    })
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    patch -p0 < ${fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/master/audio/libcanberra/files/patch-configure.diff";
      sha256 = "1f7h7ifpqvbfhqygn1b7klvwi80zmpv3538vbmq7ql7bkf1q8h31";
    }}
  '';

  postInstall = ''
    for f in $out/lib/*.la; do
      sed 's|-lltdl|-L${libtool.lib}/lib -lltdl|' -i $f
    done
  '';

  passthru = lib.optionalAttrs (gtkSupport != null) {
    gtkModule = if gtkSupport == "gtk2" then "/lib/gtk-2.0" else "/lib/gtk-3.0/";
  };

  meta = with lib; {
    description = "An implementation of the XDG Sound Theme and Name Specifications";
    longDescription = ''
      libcanberra is an implementation of the XDG Sound Theme and Name
      Specifications, for generating event sounds on free desktops
      such as GNOME.  It comes with several backends (ALSA,
      PulseAudio, OSS, GStreamer, null) and is designed to be
      portable.
    '';
    homepage = "http://0pointer.de/lennart/projects/libcanberra/";
    license = licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = platforms.unix;
    # canberra-gtk-module.c:28:10: fatal error: 'gdk/gdkx.h' file not found
    # #include <gdk/gdkx.h>
    broken = stdenv.isDarwin && (gtkSupport == "gtk3");
  };
}
