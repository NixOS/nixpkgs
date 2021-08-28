{ lib, stdenv, cmake, fetchurl, pkg-config, jansson, zlib }:

let
  version = "1.10.2";
in stdenv.mkDerivation {
  pname = "avro-c";
  inherit version;

  src = fetchurl {
    url = "mirror://apache/avro/avro-${version}/c/avro-c-${version}.tar.gz";
    sha256 = "sha256-rj+zK+xKBon1Rn4JIBGS7cbo80ITTvBq1FLKhw9Wt+I=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ jansson zlib ];

  meta = with lib; {
    description = "A C library which implements parts of the Avro Specification";
    homepage = "https://avro.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ lblasc ];
    platforms = platforms.all;
  };
}
