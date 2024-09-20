{ stdenv, lib, fetchurl, fetchpatch, pkg-config, libtool
, gtk2-x11, gtk3-x11 , gtkSupport ? null
, libpulseaudio, gst_all_1, libvorbis, libcap, systemd
, Carbon, CoreServices, AppKit
, withAlsa ? stdenv.isLinux, alsa-lib }:

stdenv.mkDerivation rec {
  pname = "libcanberra";
  version = "0.30";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/libcanberra/${pname}-${version}.tar.xz";
    sha256 = "0wps39h8rx2b00vyvkia5j40fkak3dpipp1kzilqla0cgvk73dn2";
  };

  outputs = [ "out" "dev" ];

  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libpulseaudio libvorbis
    libtool # in buildInputs rather than nativeBuildInputs since libltdl is used (not libtool itself)
  ] ++ (with gst_all_1; [ gstreamer gst-plugins-base ])
    ++ lib.optional (gtkSupport == "gtk2") gtk2-x11
    ++ lib.optional (gtkSupport == "gtk3") gtk3-x11
    ++ lib.optionals stdenv.isDarwin [ Carbon CoreServices AppKit ]
    ++ lib.optionals stdenv.isLinux [ libcap systemd ]
    ++ lib.optional withAlsa alsa-lib;

  configureFlags = [ "--disable-oss" ]
    ++ lib.optional stdenv.isLinux "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system";

  patches = [
    (fetchpatch {
      name = "0001-gtk-Don-t-assume-all-GdkDisplays-are-GdkX11Displays-.patch";
      url = "http://git.0pointer.net/libcanberra.git/patch/?id=c0620e432650e81062c1967cc669829dbd29b310";
      sha256 = "0rc7zwn39yxzxp37qh329g7375r5ywcqcaak8ryd0dgvg8m5hcx9";
    })
  ] ++ lib.optionals stdenv.isDarwin [
    (fetchpatch {
      url = "https://github.com/macports/macports-ports/raw/5a7965dfea7727d1ceedee46c7b0ccee9cb23468/audio/libcanberra/files/patch-configure.diff";
      sha256 = "sha256-pEJy1krciUEg5BFIS8FJ4BubjfS/nt9aqi6BLnS1+4M=";
      extraPrefix = "";
    })
    (fetchpatch {
      url = "https://github.com/macports/macports-ports/raw/5a7965dfea7727d1ceedee46c7b0ccee9cb23468/audio/libcanberra/files/dynamic_lookup-11.patch";
      sha256 = "sha256-nUjha2pKh5VZl0ZZzcr9NTo1TVuMqF4OcLiztxW+ofQ=";
      extraPrefix = "";
    })
  ];

  postInstall = ''
    for f in $out/lib/*.la; do
      sed 's|-lltdl|-L${libtool.lib}/lib -lltdl|' -i $f
    done
  '';

  passthru = lib.optionalAttrs (gtkSupport != null) {
    gtkModule = if gtkSupport == "gtk2" then "/lib/gtk-2.0" else "/lib/gtk-3.0/";
  };

  meta = with lib; {
    description = "Implementation of the XDG Sound Theme and Name Specifications";
    mainProgram = "canberra-gtk-play";
    longDescription = ''
      libcanberra is an implementation of the XDG Sound Theme and Name
      Specifications, for generating event sounds on free desktops
      such as GNOME.  It comes with several backends (ALSA,
      PulseAudio, OSS, GStreamer, null) and is designed to be
      portable.
    '';
    homepage = "http://0pointer.de/lennart/projects/libcanberra/";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ RossComputerGuy ];
    platforms = platforms.unix;
  };
}
