{ stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "marl";
  version = "1.0.0";  # Based on marl's CHANGES.md

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    sha256 = "0pnbarbyv82h05ckays2m3vgxzdhpcpg59bnzsddlb5v7rqhw51w";
    rev = "40209e952f5c1f3bc883d2b7f53b274bd454ca53";
  };

  nativeBuildInputs = [ cmake ];

  # Turn on the flag to install after building the library.
  cmakeFlags = ["-DMARL_INSTALL=ON"];

  meta = with stdenv.lib; {
    homepage = "https://github.com/google/marl";
    description = "A hybrid thread / fiber task scheduler written in C++ 11";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ breakds ];
  };
}
