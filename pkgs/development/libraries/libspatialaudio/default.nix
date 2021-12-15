{ lib, stdenv, fetchFromGitHub, cmake, libmysofa, zlib }:
stdenv.mkDerivation {
  name = "libspatialaudio";
  src = fetchFromGitHub {
    owner = "videolabs";
    repo = "libspatialaudio";
    rev = "0.3.0";
    hash = "sha256-sPnQPD41AceXM4uGqWXMYhuQv0TUkA6TZP8ChxUFIoI=";
  };
  buildInputs = [ cmake libmysofa zlib ];
  configurePhase = "cmake -DCMAKE_INSTALL_PREFIX=$out .";

  meta = {
    description =
      "Ambisonic encoding / decoding and binauralization library in C++";
    homepage = "https://github.com/videolabs/libspatialaudio";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}

