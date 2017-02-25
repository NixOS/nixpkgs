{ stdenv, fetchFromGitHub, boost, cmake, curl }:

stdenv.mkDerivation rec {
  name = "leatherman-${version}";
  version = "0.10.1";

  src = fetchFromGitHub {
    sha256 = "0kjk3xq7v6bqq35ymj9vr9xz5kpcka51ms6489pm48adyaf53hs7";
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
