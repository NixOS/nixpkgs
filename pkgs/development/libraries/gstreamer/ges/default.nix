{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, python3
, bash-completion
, gst-plugins-base
, gst-plugins-bad
, gst-devtools
, libxml2
, flex
, gettext
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "gst-editing-services";
  version = "1.18.2";

  outputs = [
    "out"
    "dev"
    # "devdoc" # disabled until `hotdoc` is packaged in nixpkgs
  ];

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0pv2k8zlpn3vv2sdlspi3m63ixcwzi90pjly2ypbkg59ab97rb15";
  };

  patches = [
    ./fix_pkgconfig_includedir.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    gobject-introspection
    gst-devtools
    python3
    flex

    # documentation
    # TODO add hotdoc here
  ];

  buildInputs = [
    bash-completion
    libxml2
  ];

  propagatedBuildInputs = [
    gst-plugins-base
    gst-plugins-bad
  ];

  mesonFlags = [
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
