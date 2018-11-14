{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "protozero-${version}";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "protozero";
    rev = "v${version}";
    sha256 = "0lalk6hp7hqfn4fhhl2zb214idwm4y8dj32vi383arckzmsryhiw";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Minimalistic protocol buffer decoder and encoder in C++";
    homepage = "https://github.com/mapbox/protozero";
    license = with licenses; [ bsd2 asl20 ];
    maintainers = with maintainers; [ das-g ];
  };
}
