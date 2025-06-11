{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  file,
  glibmm,
  gst_all_1,
  gnome,
  apple-sdk_gstreamer,
}:

stdenv.mkDerivation rec {
  pname = "gstreamermm";
  version = "1.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0q4dx9sncqbwgpzma0zvj6zssc279yl80pn8irb95qypyyggwn5y";
  };

  patches = [
    (fetchpatch {
      name = "${pname}-${version}.fix-build-against-glib-2.68.patch";
      url = "https://gitlab.gnome.org/GNOME/gstreamermm/-/commit/37116547fb5f9066978e39b4cf9f79f2154ad425.patch";
      sha256 = "sha256-YHtmOiOl4POwas3eWHsew3IyGK7Aq22MweBm3JPwyBM=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_gstreamer
  ];

  nativeBuildInputs = [
    pkg-config
    file
  ];

  propagatedBuildInputs = [
    glibmm
    gst_all_1.gst-plugins-base
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "gst_all_1.gstreamermm";
      packageName = "gstreamermm";
      versionPolicy = "odd-unstable";
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
