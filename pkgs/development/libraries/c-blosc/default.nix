{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "c-blosc";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc";
    rev = "v${version}";
    sha256 = "1asp3xmbvdnz1mj1pl1ykzz61cybvkxz3cdn43zh1z0x1qlgwm80";
  };

  buildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A blocking, shuffling and loss-less compression library";
    homepage = https://www.blosc.org;
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
