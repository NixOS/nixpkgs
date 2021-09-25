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
  version = "unstable-2021-06-02";

  src = fetchgit {
    url = "git://linuxtv.org/libcamera.git";
    rev = "143b252462b9b795a1286a30349348642fcb87f5";
    sha256 = "0mlwgd3rxagzhmc94lnn6snriyqvfdpz8r8f58blcf16859galyl";
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
