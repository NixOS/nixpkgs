{ stdenv
, fetchurl
, lib
, pkg-config
, meson
, ninja
, gettext
, python3
, gstreamer
, graphene
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
, libXext
, libXi
, libXv
, libdrm
, enableWayland ? stdenv.isLinux
, wayland-scanner
, wayland
, wayland-protocols
, enableAlsa ? stdenv.isLinux
, alsa-lib
# TODO: fix once x86_64-darwin sdk updated
, enableCocoa ? (stdenv.isDarwin && stdenv.isAarch64)
, Cocoa
, OpenGL
, enableGl ? (enableX11 || enableWayland || enableCocoa)
, enableCdparanoia ? (!stdenv.isDarwin)
, cdparanoia
, glib
, testers
# Checks meson.is_cross_build(), so even canExecute isn't enough.
, enableDocumentation ? stdenv.hostPlatform == stdenv.buildPlatform
, hotdoc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gst-plugins-base";
  version = "1.24.3";

  outputs = [ "out" "dev" ];

  separateDebugInfo = true;

  src = let
    inherit (finalAttrs) pname version;
  in fetchurl {
    url = "https://gstreamer.freedesktop.org/src/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-8QlDl+qnky8G5X67sHWqM6osduS3VjChawLI1K9Ggy4=";
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
    gobject-introspection
  ] ++ lib.optionals enableDocumentation [
    hotdoc
  ] ++ lib.optionals enableWayland [
    wayland-scanner
  ];

  buildInputs = [
    graphene
    orc
    libtheora
    libintl
    libopus
    isocodes
    libpng
    libjpeg
    tremor
    pango
  ] ++ lib.optionals (!stdenv.isDarwin) [
    libdrm
    libGL
    libvisual
  ] ++ lib.optionals stdenv.isDarwin [
    OpenGL
  ] ++ lib.optionals enableAlsa [
    alsa-lib
  ] ++ lib.optionals enableX11 [
    libXext
    libXi
    libXv
  ] ++ lib.optionals enableWayland [
    wayland
    wayland-protocols
  ] ++ lib.optional enableCocoa Cocoa
    ++ lib.optional enableCdparanoia cdparanoia;

  propagatedBuildInputs = [
    gstreamer
  ] ++ lib.optionals (!stdenv.isDarwin) [
    libdrm
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    # See https://github.com/GStreamer/gst-plugins-base/blob/d64a4b7a69c3462851ff4dcfa97cc6f94cd64aef/meson_options.txt#L15 for a list of choices
    "-Dgl_winsys=${lib.concatStringsSep "," (lib.optional enableX11 "x11" ++ lib.optional enableWayland "wayland" ++ lib.optional enableCocoa "cocoa")}"
    (lib.mesonEnable "doc" enableDocumentation)
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-Dtests=disabled"
  ]
  ++ lib.optional (!enableX11) "-Dx11=disabled"
  # TODO How to disable Wayland?
  ++ lib.optional (!enableGl) "-Dgl=disabled"
  ++ lib.optional (!enableAlsa) "-Dalsa=disabled"
  ++ lib.optional (!enableCdparanoia) "-Dcdparanoia=disabled"
  ++ lib.optionals stdenv.isDarwin [
    "-Ddrm=disabled"
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

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Base GStreamer plug-ins and helper libraries";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    pkgConfigModules = [
      "gstreamer-audio-1.0"
      "gstreamer-base-1.0"
      "gstreamer-net-1.0"
      "gstreamer-video-1.0"
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };
})
