{ stdenv, fetchurl, perl, python, ruby, bison, gperf, cmake
, pkgconfig, gettext, gobjectIntrospection
, gtk2, gtk3, wayland, libwebp, enchant
, libxml2, libsoup, libsecret, libxslt, harfbuzz, libpthreadstubs
, gst-plugins-base
}:

stdenv.mkDerivation rec {
  name = "webkitgtk-${version}";
  version = "2.6.4";

  meta = with stdenv.lib; {
    description = "Web content rendering engine, GTK+ port";
    homepage = "http://webkitgtk.org/";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ iyzsong koral ];
  };

  preConfigure = "patchShebangs Tools";

  src = fetchurl {
    url = "http://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "16rffxkz4w3sd7w4j3z3dycny8sdqxrz62yq4bgcmffrxlj5xvxy";
  };

  patches = [ ./finding-harfbuzz-icu.patch ];

  cmakeFlags = [ "-DPORT=GTK" ];

  nativeBuildInputs = [
    cmake perl python ruby bison gperf
    pkgconfig gettext gobjectIntrospection
  ];

  buildInputs = [
    gtk2 wayland libwebp enchant
    libxml2 libsecret libxslt harfbuzz libpthreadstubs
    gst-plugins-base
  ];

  propagatedBuildInputs = [
    libsoup gtk3
  ];

  # enableParallelBuilding = true; # build problems on Hydra
}
