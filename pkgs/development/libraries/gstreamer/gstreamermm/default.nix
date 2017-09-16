{ stdenv, fetchurl, pkgconfig, file, glibmm, gst_all_1 }:

let
  ver_maj = "1.8";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "gstreamermm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url    = "mirror://gnome/sources/gstreamermm/${ver_maj}/${name}.tar.xz";
    sha256 = "0i4sk6ns4dyi4szk45bkm4kvl57l52lgm15p2wg2rhx2gr2w3qry";
  };

  patches = [
    (fetchurl {
      url = https://bug783628.bugzilla-attachments.gnome.org/attachment.cgi?id=354765;
      sha256 = "082510a934bl05mz4cyakp8mfmd97cdj7vdrbvyqc4g58dcskvz0";
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig file ];

  propagatedBuildInputs = [ glibmm gst_all_1.gst-plugins-base ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "C++ interface for GStreamer";
    homepage = https://gstreamer.freedesktop.org/bindings/cplusplus.html;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ romildo ];
    platforms = platforms.unix;
  };

}
