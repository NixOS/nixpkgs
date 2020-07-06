{ stdenv, fetchFromGitHub, boost, cmake, curl, ruby }:

stdenv.mkDerivation rec {
  pname = "leatherman";
  version = "1.12.0";

  src = fetchFromGitHub {
    sha256 = "00qigglp67a14ki4dhjxd3j540a80rkmzhysx7hra8v2rgbsqgj8";
    rev = version;
    repo = "leatherman";
    owner = "puppetlabs";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost curl ruby ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/puppetlabs/leatherman/";
    description = "A collection of C++ and CMake utility libraries";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.unix;
  };

}
