{ stdenv
, fetchgit
, lib
, meson
, ninja
, pkg-config
, boost
, gnutls
, openssl
, libevent
, lttng-ust
, gst_all_1
, gtest
, graphviz
, doxygen
, python3
, python3Packages
}:

stdenv.mkDerivation {
  pname = "libcamera";
  version = "unstable-2021-09-24";

  src = fetchgit {
    url = "https://git.libcamera.org/libcamera/libcamera.git";
    rev = "40f5fddca7f774944a53f58eeaebc4db79c373d8";
    sha256 = "0jklgdv5ma4nszxibms5lkf5d2ips7ncynwa1flglrhl5bl4wkzz";
  };

  postPatch = ''
    patchShebangs utils/
  '';

  buildInputs = [
    # IPA and signing
    gnutls
    openssl
    boost

    # gstreamer integration
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base

    # cam integration
    libevent

    # lttng tracing
    lttng-ust
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
    gtest
    graphviz
    doxygen
  ];

  mesonFlags = [ "-Dv4l2=true" "-Dqcam=disabled" ];

  # Fixes error on a deprecated declaration
  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  meta = with lib; {
    description = "An open source camera stack and framework for Linux, Android, and ChromeOS";
    homepage = "https://libcamera.org";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ citadelcore ];
  };
}
