{ lib, stdenv, fetchurl, cmake, boost, ffmpeg, zlib }:

let frameworks = (import <nixpkgs> {}).darwin.apple_sdk.frameworks;
in stdenv.mkDerivation rec {
  pname = "chromaprint";
  version = "1.5.0";

  src = fetchurl {
    url = "https://github.com/acoustid/chromaprint/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "0sknmyl5254rc55bvkhfwpl4dfvz45xglk1rq8zq5crmwq058fjp";
  };

  nativeBuildInputs = [ cmake ];

  darwinInputs = [
    frameworks.Accelerate
    frameworks.CoreGraphics
    frameworks.CoreVideo
    zlib
    ];
  buildInputs = [ boost ffmpeg ] ++ lib.optional stdenv.isDarwin darwinInputs;

  cmakeFlags = [ "-DBUILD_EXAMPLES=ON" "-DBUILD_TOOLS=ON" ];

  meta = with stdenv.lib; {
    homepage = "https://acoustid.org/chromaprint";
    description = "AcoustID audio fingerprinting library";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
