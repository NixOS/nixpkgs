{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "protozero";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "protozero";
    rev = "v${version}";
    sha256 = "0fdihfl5j68wayjjxvpvhvnjq1anzcfnfl09f68wpzbkg3zmhblz";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Minimalistic protocol buffer decoder and encoder in C++";
    homepage = "https://github.com/mapbox/protozero";
    license = with licenses; [ bsd2 asl20 ];
    maintainers = with maintainers; [ das-g ];
  };
}
