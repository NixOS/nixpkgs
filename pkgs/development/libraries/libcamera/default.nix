{ stdenv
, fetchgit
, lib
, meson
, ninja
, pkg-config
, makeFontsConf
, boost
, gnutls
, openssl
, libdrm
, libevent
, lttng-ust
, gst_all_1
, gtest
, graphviz
, doxygen
, python3
, python3Packages
, systemd # for libudev
}:

stdenv.mkDerivation {
  pname = "libcamera";
  version = "unstable-2022-01-03";

  src = fetchgit {
    url = "https://git.libcamera.org/libcamera/libcamera.git";
    rev = "1db1e31e664c1f613dc964d8519fe75d67b154b6";
    hash = "sha256-pXYPIU9xDWA870Gp1Jgizi5xnUHRvTqEq/ofFXdVZdg=";
  };

  postPatch = ''
    patchShebangs utils/
  '';

  strictDeps = true;

  buildInputs = [
    # IPA and signing
    gnutls
    boost

    # gstreamer integration
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base

    # cam integration
    libevent
    libdrm

    # hotplugging
    systemd

    # lttng tracing
    lttng-ust

    gtest
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    python3Packages.jinja2
    python3Packages.pyyaml
    python3Packages.ply
    python3Packages.sphinx
    graphviz
    doxygen
    openssl
  ];

  mesonFlags = [
    "-Dv4l2=true"
    "-Dqcam=disabled"
    "-Dlc-compliance=disabled" # tries unconditionally to download gtest when enabled
    ];

  # Fixes error on a deprecated declaration
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  # Silence fontconfig warnings about missing config
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = []; };

  meta = with lib; {
    description = "An open source camera stack and framework for Linux, Android, and ChromeOS";
    homepage = "https://libcamera.org";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ citadelcore ];
  };
}
