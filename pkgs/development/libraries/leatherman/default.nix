{ stdenv, fetchFromGitHub, boost, cmake, curl, ruby }:

stdenv.mkDerivation rec {
  name = "leatherman-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    sha256 = "15kg6vdr1iav5x3pzwvrdsi54lbl8zh2xwqlp03gaq4n3kg5wj3y";
    rev = version;
    repo = "leatherman";
    owner = "puppetlabs";
  };

  buildInputs = [ boost cmake curl ruby ];

  meta = with stdenv.lib; {
    homepage = https://github.com/puppetlabs/leatherman/;  
    description = "A collection of C++ and CMake utility libraries";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
