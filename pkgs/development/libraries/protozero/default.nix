{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "protozero";
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "protozero";
    rev = "v${version}";
    sha256 = "1hfijpfylf1c71wa3mk70gjc88b6k1q7cxb87cwqdflw5q2x8ma6";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Minimalistic protocol buffer decoder and encoder in C++";
    homepage = "https://github.com/mapbox/protozero";
    license = with licenses; [ bsd2 asl20 ];
    maintainers = with maintainers; [ das-g ];
  };
}
