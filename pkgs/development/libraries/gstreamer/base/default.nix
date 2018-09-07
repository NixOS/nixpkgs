{ stdenv, fetchurl, fetchpatch, lib
, pkgconfig, meson, ninja, gettext, gobjectIntrospection
, python, gstreamer, orc, pango, libtheora
, libintl, libopus
, enableX11 ? stdenv.isLinux, libXv
, enableWayland ? stdenv.isLinux, wayland
, enableAlsa ? stdenv.isLinux, alsaLib
, enableCocoa ? false, darwin
, enableCdparanoia ? (!stdenv.isDarwin), cdparanoia }:

stdenv.mkDerivation rec {
  name = "gst-plugins-base-1.14.0";

  meta = with lib; {
    description = "Base plugins and helper libraries";
    homepage = https://gstreamer.freedesktop.org;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gst-plugins-base/${name}.tar.xz";
    sha256 = "0h39bcp7fcd9kgb189lxr8l0hm0almvzpzgpdh1jpq2nzxh4d43y";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig python gettext gobjectIntrospection ]

  # Broken meson with Darwin. Should hopefully be fixed soon. Tracking
  # in https://bugzilla.gnome.org/show_bug.cgi?id=781148.
  ++ lib.optionals (!stdenv.isDarwin) [ meson ninja ];

  # TODO How to pass these to Meson?
  configureFlags = [
    "--enable-x11=${if enableX11 then "yes" else "no"}"
    "--enable-wayland=${if enableWayland then "yes" else "no"}"
    "--enable-cocoa=${if enableCocoa then "yes" else "no"}"
  ]

  # Introspection fails on my MacBook currently
  ++ lib.optional stdenv.isDarwin "--disable-introspection";

  buildInputs = [ orc libtheora libintl libopus ]
    ++ lib.optional enableAlsa alsaLib
    ++ lib.optionals enableX11 [ libXv pango ]
    ++ lib.optional enableWayland wayland
    ++ lib.optional enableCocoa darwin.apple_sdk.frameworks.Cocoa
    ++ lib.optional enableCdparanoia cdparanoia;

  propagatedBuildInputs = [ gstreamer ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  doCheck = false; # fails, wants DRI access for OpenGL

  patches = [
    (fetchpatch {
        url = "https://bug794856.bugzilla-attachments.gnome.org/attachment.cgi?id=370414";
        sha256 = "07x43xis0sr0hfchf36ap0cibx0lkfpqyszb3r3w9dzz301fk04z";
    })
    ./fix_pkgconfig_includedir.patch
  ];
}
