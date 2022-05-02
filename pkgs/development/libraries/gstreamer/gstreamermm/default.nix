{ lib
, stdenv
, fetchFromGitLab
, autoconf
, automake
, libtool
, perl
, mm-common
, pkg-config
, file
, glibmm
, gst_all_1
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "gstreamermm";
  version = "unstable-2022-05-03";

  src = fetchFromGitLab {
    # https://gitlab.gnome.org/GNOME/gstreamermm
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gstreamermm";
    # https://gitlab.gnome.org/GNOME/gstreamermm/-/merge_requests/5
    rev = "89b2ece5cab32b5094686bb96426a004029a9449";
    sha256 = "sha256-b6719eTiBJ21eNA/tgul6GuAkKF0gmsbbG2x9NAtW3s=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    mm-common
    pkg-config
    file
    (perl.withPackages (p: [ p.XMLParser ]))
  ];

  propagatedBuildInputs = [
    glibmm
    gst_all_1.gst-plugins-base
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [
    # Enable generating of binding code (pre-generated C++ files not available in Git).
    "--enable-maintainer-mode"
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "gst_all_1.gstreamermm";
    };
  };

  meta = with lib; {
    description = "C++ interface for GStreamer";
    homepage = "https://gstreamer.freedesktop.org/bindings/cplusplus.html";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
