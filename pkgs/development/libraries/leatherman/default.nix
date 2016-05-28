{ stdenv, fetchFromGitHub, boost, cmake, curl }:

stdenv.mkDerivation rec {
  name = "leatherman-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    sha256 = "1m37zcr11a2g08wbkpxgav97m2fr14in2zhdhhv5krci5i2grzd7";
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
