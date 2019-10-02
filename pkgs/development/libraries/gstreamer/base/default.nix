{ stdenv
, fetchurl
, lib
, pkgconfig
, meson
, ninja
, gettext
, gobject-introspection
, python3
, gstreamer
, orc
, pango
, libtheora
, libintl
, libopus
, isocodes
, libjpeg
, libvisual
, tremor # provides 'virbisidec'
, libGL
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, enableX11 ? stdenv.isLinux
, libXv
, enableWayland ? stdenv.isLinux
, wayland
, enableAlsa ? stdenv.isLinux
, alsaLib
, enableCocoa ? false
, darwin
, enableCdparanoia ? (!stdenv.isDarwin)
, cdparanoia
}:

stdenv.mkDerivation rec {
  pname = "gst-plugins-base";
  version = "1.16.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0aybbwnzm15074smdk2bamj3ssck3hjvmilvgh49f19xjf4w8g2w";
  };

  patches = [
    ./fix_pkgconfig_includedir.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    python3
    gettext
    gobject-introspection

    # docs
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
  ];

  buildInputs = [
    orc
    libtheora
    libintl
    libopus
    isocodes
    libjpeg
    tremor
    libGL
  ] ++ lib.optional (!stdenv.isDarwin) libvisual
    ++ lib.optional enableAlsa alsaLib
    ++ lib.optionals enableX11 [ libXv pango ]
    ++ lib.optional enableWayland wayland
    ++ lib.optional enableCocoa darwin.apple_sdk.frameworks.Cocoa
    ++ lib.optional enableCdparanoia cdparanoia;

  propagatedBuildInputs = [
    gstreamer
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Dgl-graphene=disabled" # not packaged in nixpkgs as of writing
    # See https://github.com/GStreamer/gst-plugins-base/blob/d64a4b7a69c3462851ff4dcfa97cc6f94cd64aef/meson_options.txt#L15 for a list of choices
    "-Dgl_winsys=[${lib.concatStringsSep "," (lib.optional enableX11 "x11" ++ lib.optional enableWayland "wayland" ++ lib.optional enableCocoa "cocoa")}]"
    # We must currently disable gtk_doc API docs generation,
    # because it is not compatible with some features being disabled.
    # See for example
    #     https://gitlab.freedesktop.org/gstreamer/gst-plugins-base/issues/564
    # for it failing because some Wayland symbols are missing.
    # This problem appeared between 1.15.1 and 1.16.0.
    # In 1.18 they should switch to hotdoc, which should make this issue irrelevant.
    "-Dgtk_doc=disabled"
  ]
  ++ lib.optional (!enableX11) "-Dx11=disabled"
  # TODO How to disable Wayland?
  ++ lib.optional (!enableAlsa) "-Dalsa=disabled"
  ++ lib.optional (!enableCdparanoia) "-Dcdparanoia=disabled";

  postPatch = ''
    patchShebangs common/scangobj-merge.py
  '';

  doCheck = false; # fails, wants DRI access for OpenGL

  meta = with lib; {
    description = "Base GStreamer plug-ins and helper libraries";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
