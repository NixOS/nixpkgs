{ stdenv, lib, fetchurl, fetchpatch, pkgconfig, libtool
, gtk ? null
, libpulseaudio, gst_all_1, libvorbis, libcap
, withAlsa ? stdenv.isLinux, alsaLib }:

stdenv.mkDerivation rec {
  name = "libcanberra-0.30";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/libcanberra/${name}.tar.xz";
    sha256 = "0wps39h8rx2b00vyvkia5j40fkak3dpipp1kzilqla0cgvk73dn2";
  };

  nativeBuildInputs = [ pkgconfig libtool ];
  buildInputs = [
    libpulseaudio libvorbis gtk
  ] ++ (with gst_all_1; [ gstreamer gst-plugins-base ])
    ++ lib.optional stdenv.isLinux libcap
    ++ lib.optional withAlsa alsaLib;

  configureFlags = [ "--disable-oss" ];

  patchFlags = "-p0";
  patches = stdenv.lib.optional stdenv.isDarwin
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/master/audio/libcanberra/files/patch-configure.diff";
      sha256 = "1f7h7ifpqvbfhqygn1b7klvwi80zmpv3538vbmq7ql7bkf1q8h31";
    });

  postInstall = ''
    for f in $out/lib/*.la; do
      sed 's|-lltdl|-L${libtool.lib}/lib -lltdl|' -i $f
    done
  '';

  passthru = {
    gtkModule = "/lib/gtk-2.0/";
  };

  meta = {
    description = "An implementation of the XDG Sound Theme and Name Specifications";

    longDescription = ''
      libcanberra is an implementation of the XDG Sound Theme and Name
      Specifications, for generating event sounds on free desktops
      such as GNOME.  It comes with several backends (ALSA,
      PulseAudio, OSS, GStreamer, null) and is designed to be
      portable.
    '';

    homepage = http://0pointer.de/lennart/projects/libcanberra/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
