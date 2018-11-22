{ stdenv, fetchFromGitHub, boost, cmake, curl, ruby }:

stdenv.mkDerivation rec {
  name = "leatherman-${version}";
  version = "1.5.3";

  src = fetchFromGitHub {
    sha256 = "04b2wii5d0ypar8wrk0msybdq01z1r23xsvnn67bi2mffvczi5l2";
    rev = version;
    repo = "leatherman";
    owner = "puppetlabs";
  };

  buildInputs = [ boost cmake curl ruby ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/puppetlabs/leatherman/;  
    description = "A collection of C++ and CMake utility libraries";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
