{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "protozero-${version}";
  version = "1.6.7";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "protozero";
    rev = "v${version}";
    sha256 = "1ryvn3iwxiaih3mvyy45nbwxnhzfc8vby0xh9m6d6fpakhcpf6s3";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Minimalistic protocol buffer decoder and encoder in C++";
    homepage = "https://github.com/mapbox/protozero";
    license = with licenses; [ bsd2 asl20 ];
    maintainers = with maintainers; [ das-g ];
  };
}
