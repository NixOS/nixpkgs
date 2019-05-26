{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libobjc2";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "gnustep";
    repo = "libobjc2";
    rev = "v${version}";
    sha256 = "00pscl3ly3rv6alf9vk70kxnnxq2rfgpc1ylcv6cgjs9jxdnrqmn";
  };

  nativeBuildInputs = [ cmake ];

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
