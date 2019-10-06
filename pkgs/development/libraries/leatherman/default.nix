{ stdenv, fetchFromGitHub, boost, cmake, curl, ruby }:

stdenv.mkDerivation rec {
  pname = "leatherman";
  version = "1.7.2";

  src = fetchFromGitHub {
    sha256 = "1k70fx9i4prw0vp5680ijs1ldbwd7gmvpav7jfqvpbcm3zblkc23";
    rev = version;
    repo = "leatherman";
    owner = "puppetlabs";
  };

  NIX_CFLAGS_COMPILE = [ "-Wno-error=ignored-qualifiers" "-Wno-error=class-memaccess" "-Wno-error=catch-value" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost curl ruby ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/puppetlabs/leatherman/;  
    description = "A collection of C++ and CMake utility libraries";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
