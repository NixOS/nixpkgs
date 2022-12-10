{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "librtprocess";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "CarVac";
    repo = pname;
    rev = version;
    sha256 = "sha256-/1o6SWUor+ZBQ6RsK2PoDRu03jcVRG58PNYFttriH2w=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/CarVac/librtprocess";
    description = "Highly optimized library for processing RAW images";
    license = licenses.gpl3;
    maintainers = with maintainers; [ hjones2199 ];
    platforms = [ "x86_64-linux" ];
  };
}
