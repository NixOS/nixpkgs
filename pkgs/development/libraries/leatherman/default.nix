{ stdenv, fetchFromGitHub, boost, cmake, curl }:

stdenv.mkDerivation rec {
  name = "leatherman-${version}";
  version = "0.4.2";

  src = fetchFromGitHub {
    sha256 = "07bgv99lzzhxy4l7mdyassxqy33zv7arvfw63bymsqavppphqlrr";
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
