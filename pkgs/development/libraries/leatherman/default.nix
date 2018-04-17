{ stdenv, fetchFromGitHub, boost, cmake, curl, ruby }:

stdenv.mkDerivation rec {
  name = "leatherman-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    sha256 = "0whlyzz0imv4lm69xkwhcd6jzh3s0rzlqjmwimbqz96p4771ivpd";
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
