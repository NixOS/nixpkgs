{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "codec2";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "codec2";
    rev = "v${version}";
    sha256 = "05xjsb67dzwncl2rnhg6fqih8krf38b7vmvzlsb7y9g6d1b085wg";
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
