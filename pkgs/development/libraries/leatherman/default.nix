{ stdenv, fetchFromGitHub, boost, cmake, curl }:

stdenv.mkDerivation rec {
  name = "leatherman-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    sha256 = "18nidasykbwdd9qzwc8pnzhczy6acr3rsxwvv2v3j5gq3nbsk2mc";
    rev = version;
    repo = "leatherman";
    owner = "puppetlabs";
  };

  buildInputs = [ boost cmake curl ];

  meta = with stdenv.lib; {
    homepage = https://github.com/puppetlabs/leatherman/;  
    description = "A collection of C++ and CMake utility libraries";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
