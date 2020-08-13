{ buildPythonPackage
, fetchurl
, meson
, ninja
, stdenv
, pkgconfig
, python
, pygobject3
, gobject-introspection
, gst-plugins-base
, isPy3k
, fetchpatch
}:

buildPythonPackage rec {
  pname = "gst-python";
  version = "1.16.2";

  format = "other";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/src/gst-python/${pname}-${version}.tar.xz";
    sha256 = "1a48ca66izmm8hnp608jv5isg3jxb0vlfmhns0bg9nbkilag7390";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    python
    gobject-introspection
    gst-plugins-base
  ];

  propagatedBuildInputs = [
    gst-plugins-base
    pygobject3
  ];

  patches = stdenv.lib.optionals stdenv.isDarwin [
    # Fix configure python lib detection in macOS. Remove with the next release
    (fetchpatch {
      url = "https://github.com/GStreamer/gst-python/commit/f98c206bdf01529f8ea395a719b10baf2bdf717f.patch";
      sha256 = "04n4zrnfivgr7iaqw4sjlbd882s8halc2bbbhfxqf0sg2lqwmrxg";
    })
  ] ++ [
    # Fix linking against Python 3.8
    # https://gitlab.freedesktop.org/gstreamer/gst-python/merge_requests/30
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/gstreamer/gst-python/commit/22f28155d86e27c4134de4ed2861264003fcfd23.patch";
      sha256 = "Y70qVguHUBmmRVMFBKAP0d6anBQw5W0TKyu2bAwxbQg=";
    })
  ];

  mesonFlags = [
    "-Dpython=python${if isPy3k then "3" else "2"}"
    "-Dpygi-overrides-dir=${placeholder "out"}/${python.sitePackages}/gi/overrides"
  ];

  doCheck = true;

  # TODO: Meson setup hook does not like buildPythonPackage
  # https://github.com/NixOS/nixpkgs/issues/47390
  installCheckPhase = "meson test --print-errorlogs";

  meta = {
    homepage = "https://gstreamer.freedesktop.org";

    description = "Python bindings for GStreamer";

    license = stdenv.lib.licenses.lgpl2Plus;
  };
}
