{ stdenv, fetchurl, libav_9 }:

let derivSrc = libav_9.derivSrc // rec {
  name = "libav-0.8.8";

  src = fetchurl {
    url = "http://libav.org/releases/${name}.tar.xz";
    sha256 = "1wnbmbs0z4f55y8r9bwb63l04zn383l1avy4c9x1ffb2xccgcp79";
  };
};
in stdenv.mkDerivation derivSrc

