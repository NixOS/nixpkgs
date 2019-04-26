{ stdenv, lib, fetchFromGitHub, cmake }:

let
  version = "1.9";
in

stdenv.mkDerivation rec {
  name = "libobjc2-${version}";

  src = fetchFromGitHub {
    owner = "gnustep";
    repo = "libobjc2";
    rev = "v${version}";
    sha256 = "00pscl3ly3rv6alf9vk70kxnnxq2rfgpc1ylcv6cgjs9jxdnrqmn";
  };

  buildInputs = [ cmake ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = with lib; {
    description = "Objective-C runtime for use with GNUstep";
    homepage = http://gnustep.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ashalkhakov matthewbauer ];
    platforms = platforms.unix;
    badPlatforms = [ "aarch64-linux" ];
  };
}
