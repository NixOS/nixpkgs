{ lib, stdenv, cmake, fetchFromGitHub, libmysofa, zlib }:

let version = "0.3.0";
in stdenv.mkDerivation {
  pname = "libspatialaudio";
  inherit version;

  src = fetchFromGitHub {
    owner = "videolabs";
    repo = "libspatialaudio";
    rev = version;
    hash = "sha256-sPnQPD41AceXM4uGqWXMYhuQv0TUkA6TZP8ChxUFIoI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libmysofa zlib ];

  meta = {
    description =
      "Ambisonic encoding / decoding and binauralization library in C++";
    homepage = "https://github.com/videolabs/libspatialaudio";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ krav ];
  };
}

