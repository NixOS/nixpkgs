{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "metal";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "brunocodutra";
    repo = "metal";
    rev = "v${version}";
    sha256 = "07n1aqyaixbd66l24km5ip3pkmidkx9m3saygf7cfp6vvbgmi42l";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Single-header C++11 library designed to make you love template metaprogramming";
    homepage = "https://github.com/brunocodutra/metal";
    license = licenses.mit;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.linux;
  };

}
