{ stdenv
, fetchurl
, lib
, pkg-config
, meson
, ninja
, gettext
, python3
, gstreamer
, orc
, pango
, libtheora
, libintl
, libopus
, isocodes
, libjpeg
, libpng
, libvisual
, tremor # provides 'virbisidec'
, libGL
, gobject-introspection
, enableX11 ? stdenv.isLinux
, libXv
, libXext
, enableWayland ? stdenv.isLinux
, wayland
, wayland-protocols
, enableAlsa ? stdenv.isLinux
, alsa-lib
# Enabling Cocoa seems to currently not work, giving compile
# errors. Suspected is that a newer version than clang
# is needed than 5.0 but it is not clear.
, enableCocoa ? false
, Cocoa
, OpenGL
, enableGl ? (enableX11 || enableWayland || enableCocoa)
, enableCdparanoia ? (!stdenv.isDarwin)
, cdparanoia
, glib
}:

stdenv.mkDerivation rec {
  pname = "gst-plugins-base";
  version = "1.20.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0162ly7pscymq6bsf1d5fva2k9s16zvfwyi1q6z4yfd97d0sdn4n";
  };

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    gettext
    orc
    glib
    gstreamer
    # docs
    # TODO add hotdoc here
    gobject-introspection
  ] ++ lib.optional enableWayland wayland;

  buildInputs = [
    gobject-introspection
    orc
    libtheora
    libintl
    libopus
    isocodes
    libpng
    libjpeg
    tremor
    libGL
  ] ++ lib.optional (!stdenv.isDarwin) [
    libvisual
  ] ++ lib.optionals stdenv.isDarwin [
    pango
    OpenGL
  ] ++ lib.optionals enableAlsa [
    alsa-lib
  ] ++ lib.optionals enableX11 [
    libXext
    libXv
    pango
  ] ++ lib.optionals enableWayland [
    wayland
    wayland-protocols
  ] ++ lib.optional enableCocoa Cocoa
    ++ lib.optional enableCdparanoia cdparanoia;

  propagatedBuildInputs = [
    gstreamer
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing
    "-Dgl-graphene=disabled" # not packaged in nixpkgs as of writing
    # See https://github.com/GStreamer/gst-plugins-base/blob/d64a4b7a69c3462851ff4dcfa97cc6f94cd64aef/meson_options.txt#L15 for a list of choices
    "-Dgl_winsys=${lib.concatStringsSep "," (lib.optional enableX11 "x11" ++ lib.optional enableWayland "wayland" ++ lib.optional enableCocoa "cocoa")}"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-Dtests=disabled"
  ]
  ++ lib.optional (!enableX11) "-Dx11=disabled"
  # TODO How to disable Wayland?
  ++ lib.optional (!enableGl) "-Dgl=disabled"
  ++ lib.optional (!enableAlsa) "-Dalsa=disabled"
  ++ lib.optional (!enableCdparanoia) "-Dcdparanoia=disabled"
  ++ lib.optionals stdenv.isDarwin [
    "-Dlibvisual=disabled"
  ];

  postPatch = ''
    patchShebangs \
      scripts/meson-pkg-config-file-fixup.py \
      scripts/extract-release-date-from-doap-file.py
  '';

  # This package has some `_("string literal")` string formats
  # that trip up clang with format security enabled.
  hardeningDisable = [ "format" ];

  doCheck = false; # fails, wants DRI access for OpenGL

  passthru = {
    # Downstream `gst-*` packages depending on `gst-plugins-base`
    # have meson build options like 'gl' etc. that depend
    # on these features being built in `-base`.
    # If they are not built here, then the downstream builds
    # will fail, as they, too, use `-Dauto_features=enabled`
    # which would enable these options unconditionally.
    # That means we must communicate to these downstream packages
    # if the `-base` enabled these options or not, so that
    # the can enable/disable those features accordingly.
    # The naming `*Enabled` vs `enable*` is intentional to
    # distinguish inputs from outputs (what is to be built
    # vs what was built) and to make them easier to search for.
    glEnabled = enableGl;
    waylandEnabled = enableWayland;
  };

  meta = with lib; {
    description = "Base GStreamer plug-ins and helper libraries";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
