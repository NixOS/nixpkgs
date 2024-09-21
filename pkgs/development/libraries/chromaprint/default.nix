{ lib
, stdenv
, fetchurl
, fetchpatch
, fetchpatch2
, cmake
, ninja
, ffmpeg_7
, darwin
, zlib
}:

stdenv.mkDerivation rec {
  pname = "chromaprint";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/acoustid/chromaprint/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-oarY+juLGLeNN1Wzdn+v+au2ckLgG0eOyaZOGQ8zXhw=";
  };

  patches = [
    # Use FFmpeg 5.x
    # https://github.com/acoustid/chromaprint/pull/120
    (fetchpatch {
      url = "https://github.com/acoustid/chromaprint/commit/8ccad6937177b1b92e40ab8f4447ea27bac009a7.patch";
      hash = "sha256-yO2iWmU9s2p0uJfwIdmk3jZ5HXBIQZ/NyOqG+Y5EHdg=";
      excludes = [ "package/build.sh" ];
    })
    # ffmpeg5 fix for issue #122
    # https://github.com/acoustid/chromaprint/pull/125
    (fetchpatch {
      url = "https://github.com/acoustid/chromaprint/commit/aa67c95b9e486884a6d3ee8b0c91207d8c2b0551.patch";
      hash = "sha256-dLY8FBzBqJehAofE924ayZK0HA/aKiuFhEFxL7dg6rY=";
    })
    # Fix for FFmpeg 7
    (fetchpatch2 {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/chromaprint/-/raw/74ae4c7faea2114f2d70a57755f714e348476d28/ffmpeg-7.patch";
      hash = "sha256-io+dzhDNlz+2hWhNfsyePKLQjiUvSzbv10lHVKumTEk=";
    })
  ];

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = [ ffmpeg_7 ] ++ lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ Accelerate CoreGraphics CoreVideo zlib ]);

  cmakeFlags = [ "-DBUILD_EXAMPLES=ON" "-DBUILD_TOOLS=ON" ];

  meta = with lib; {
    homepage = "https://acoustid.org/chromaprint";
    description = "AcoustID audio fingerprinting library";
    mainProgram = "fpcalc";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
