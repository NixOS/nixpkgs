{ lib, stdenv, fetchurl, cmake, boost, ffmpeg_4, darwin, zlib }:

stdenv.mkDerivation rec {
  pname = "chromaprint";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/acoustid/chromaprint/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-oarY+juLGLeNN1Wzdn+v+au2ckLgG0eOyaZOGQ8zXhw=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ ffmpeg_4 ] ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [Accelerate CoreGraphics CoreVideo zlib]);

  cmakeFlags = [ "-DBUILD_EXAMPLES=ON" "-DBUILD_TOOLS=ON" ];

  meta = with lib; {
    homepage = "https://acoustid.org/chromaprint";
    description = "AcoustID audio fingerprinting library";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
