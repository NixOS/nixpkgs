{ lib
, stdenv
, fetchurl
, fetchpatch
, boost
, libwpd
, libwpg
, pkg-config
, zlib
, gperf
, librevenge
, libxml2
, icu
, perl
, cppunit
, doxygen
}:

stdenv.mkDerivation rec {
  pname = "libvisio";
  version = "0.1.7";

  outputs = [ "out" "bin" "dev" "doc" ];

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/libvisio/${pname}-${version}.tar.xz";
    sha256 = "0k7adcbbf27l7n453cca1m6s9yj6qvb5j6bsg2db09ybf3w8vbwg";
  };

  patches = [
    # Fix build with libxml2 2.12
    # https://gerrit.libreoffice.org/c/libvisio/+/160542
    (fetchpatch {
      url = "https://gerrit.libreoffice.org/changes/libvisio~160542/revisions/2/patch?download";
      decode = "base64 -d";
      hash = "sha256-b7Ird68pHpMJg5K1rZfYcFSlMkGydjgiyzSLw+pzIis=";
    })
  ];

  strictDeps = true;
  nativeBuildInputs = [ pkg-config doxygen perl gperf ];
  buildInputs = [ boost libwpd libwpg zlib librevenge libxml2 icu cppunit ];

  doCheck = true;

  meta = with lib; {
    description = "A library providing ability to interpret and import visio diagrams into various applications";
    homepage = "https://wiki.documentfoundation.org/DLP/Libraries/libvisio";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nickcao ];
  };
}
