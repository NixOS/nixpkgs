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
    broken = true; # at 2022-09-24, logs at: https://termbin.com/n5hb
      # ../gstreamer/gstreamermm/register.h: In function 'GType Gst::register_mm_type(const gchar*)':
      # /nix/store/rwr0ly4girpnrq3sqvp3v2k40wb4hh3s-glib-2.72.3-dev/include/glib-2.0/glib/gatomic.h:113:19:
      #   error: argument 2 of '__atomic_load' must not be a pointer to a 'volatile' type
      #   113 |     __atomic_load (gapg_temp_atomic, &gapg_temp_newval, __ATOMIC_SEQ_CST);
  };

}
