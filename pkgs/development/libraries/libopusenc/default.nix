{ stdenv, fetchurl, pkgconfig, libopus }:

let
  version = "0.2.1";
in
stdenv.mkDerivation rec {
  name = "libopusenc-${version}";

  src = fetchurl {
    url = "https://archive.mozilla.org/pub/opus/libopusenc-${version}.tar.gz";
    sha256 = "1ffb0vhlymlsq70pxsjj0ksz77yfm2x0a1x8q50kxmnkm1hxp642";
  };

  outputs = [ "out" "dev" ];

  doCheck = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libopus ];

  meta = with stdenv.lib; {
    description = "Library for encoding .opus audio files and live streams";
    license = licenses.bsd3;
    homepage = http://www.opus-codec.org/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pmiddend ];
  };
}
