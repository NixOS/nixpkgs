{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "protozero-${version}";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "protozero";
    rev = "v${version}";
    sha256 = "0hcawgyj3wxqikx5xqs1ag12w8vz00gb1rzx131jq51yhzc6bwrb";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Minimalistic protocol buffer decoder and encoder in C++";
    homepage = "https://github.com/mapbox/protozero";
    license = with licenses; [ bsd2 asl20 ];
    maintainers = with maintainers; [ das-g ];
  };
}
