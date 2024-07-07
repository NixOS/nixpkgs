{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "aften";
  version = "0.0.8";
  src = fetchurl {
    url = "mirror://sourceforge/aften/${pname}-${version}.tar.bz2";
    sha256 = "02hc5x9vkgng1v9bzvza9985ifrjd7fjr7nlpvazp4mv6dr89k47";
  };

  patches = [
    # Add fallback for missing SIMD functions on ARM
    # Source https://github.com/Homebrew/homebrew-core/blob/cad412c7fb4b64925f821fcc9ac5f16a2c40f32d/Formula/aften.rb
    ./simd-fallback.patch
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DSHARED=ON" ];

  meta = with lib; {
    description = "Audio encoder which generates compressed audio streams based on ATSC A/52 specification";
    homepage = "https://aften.sourceforge.net/";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ emilytrau ];
  };
}
