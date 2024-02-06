{ stdenv
, fetchgit
, fetchpatch
, lib
, meson
, ninja
, pkg-config
, makeFontsConf
, openssl
, libdrm
, libevent
, libyaml
, lttng-ust
, gst_all_1
, gtest
, graphviz
, doxygen
, python3
, python3Packages
, systemd # for libudev
}:

stdenv.mkDerivation rec {
  pname = "libcamera";
  version = "0.1.0";

  src = fetchgit {
    url = "https://git.libcamera.org/libcamera/libcamera.git";
    rev = "v${version}";
    hash = "sha256-icHZtv25QvJEv0DlELT3cDxho3Oz2BJAMNKr5W4bshk=";
  };

  outputs = [ "out" "dev" "doc" ];

  patches = [
    (fetchpatch {
      # https://git.libcamera.org/libcamera/libcamera.git/commit/?id=6cb92b523bd60bd7718df134cc5b1eff51cf42e5
      name = "libcamera-sphinx7.0-compat.patch";
      url = "https://git.libcamera.org/libcamera/libcamera.git/patch/?id=6cb92b523bd60bd7718df134cc5b1eff51cf42e5";
      hash = "sha256-gs0EiT3gWlmRjDim+o2C0VmnoWqEouP5pNTD4XbNSdE=";
    })
  ];

  postPatch = ''
    patchShebangs utils/
  '';

  strictDeps = true;

  buildInputs = [
    # IPA and signing
    openssl

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

    # yamlparser
    libyaml

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
    # Avoid blanket -Werror to evade build failures on less
    # tested compilers.
    "-Dwerror=false"
    ];

  # Fixes error on a deprecated declaration
  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  # Silence fontconfig warnings about missing config
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = []; };

  # libcamera signs the IPA module libraries at install time, but they are then
  # modified by stripping and RPATH fixup. Therefore, we need to generate the
  # signatures again ourselves.
  #
  # If this is not done, libcamera will still try to load them, but it will
  # isolate them in separate processes, which can cause crashes for IPA modules
  # that are not designed for this (notably ipa_rpi.so).
  postFixup = ''
    ../src/ipa/ipa-sign-install.sh src/ipa-priv-key.pem $out/lib/libcamera/ipa_*.so
  '';

  meta = with lib; {
    description = "An open source camera stack and framework for Linux, Android, and ChromeOS";
    homepage = "https://libcamera.org";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ citadelcore ];
  };
}
