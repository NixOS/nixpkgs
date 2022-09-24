{ lib, stdenv, fetchurl, pkg-config, file, glibmm, gst_all_1, gnome }:
stdenv.mkDerivation rec {
  pname = "gstreamermm";
  version = "1.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0q4dx9sncqbwgpzma0zvj6zssc279yl80pn8irb95qypyyggwn5y";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config file ];

  propagatedBuildInputs = [ glibmm gst_all_1.gst-plugins-base ];

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
