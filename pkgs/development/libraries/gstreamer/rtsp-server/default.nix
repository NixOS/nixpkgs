{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, python3
, gettext
, gobject-introspection
, gst-plugins-base
, gst-plugins-bad
}:

stdenv.mkDerivation rec {
  pname = "gst-rtsp-server";
  version = "1.18.1";

  src = fetchurl {
    url = "${meta.homepage}/src/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0m7p7sarvi6n9pz0rrl9k3gp3l5s42qs8z0165kyd6fiqdjjia0h";
  };

  outputs = [
    "out"
    "dev"
    # "devdoc" # disabled until `hotdoc` is packaged in nixpkgs
  ];

  patches = [
    # To use split outputs, we need this so double prefix won't be used in the
    # pkg-config files. Hopefully, this won't be needed on the next release,
    # _if_
    # https://gitlab.freedesktop.org/gstreamer/gst-rtsp-server/merge_requests/1
    # will be merged. For the current release, this merge request won't apply.
    ./fix_pkgconfig_includedir.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    gobject-introspection
    pkgconfig
    python3

    # documentation
    # TODO add hotdoc here
  ];

  buildInputs = [
    gst-plugins-base
    gst-plugins-bad
  ];

  mesonFlags = [
    "-Dexamples=disabled" # requires many dependencies and probably not useful for our users
    "-Ddoc=disabled" # `hotdoc` not packaged in nixpkgs as of writing
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  meta = with stdenv.lib; {
    description = "GStreamer RTSP server";
    homepage = "https://gstreamer.freedesktop.org";
    longDescription = ''
      A library on top of GStreamer for building an RTSP server.
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bkchr ];
  };
}
