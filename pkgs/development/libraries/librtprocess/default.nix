{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "librtprocess";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "CarVac";
    repo = pname;
    rev = version;
    sha256 = "1bivy3rymmmkdx5phbxq4qaq15hw633dgpks57z9ara15mh817xx";
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
