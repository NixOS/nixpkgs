{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "codec2";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "codec2";
    rev = "v${version}";
    hash = "sha256-2/Ef5cEe7Kr3a/D8u4BgvTQM6M6vglXsF+ccstFHDUw=";
  };

  nativeBuildInputs = [ cmake ];

  # Swap keyword order to satisfy SWIG parser
  postFixup = ''
    sed -r -i 's/(\<_Complex)(\s+)(float|double)/\3\2\1/' $out/include/$pname/freedv_api.h
  '';

  meta = with lib; {
    description = "Speech codec designed for communications quality speech at low data rates";
    homepage = "http://www.rowetel.com/blog/?page_id=452";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ markuskowa ];
  };
}
