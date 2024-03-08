{ lib
, stdenv
, fetchurl
, fetchpatch
, cmake
, boost
, python3
}:

stdenv.mkDerivation rec {
  pname = "avro-c++";
  version = "1.11.3";

  src = fetchurl {
    url = "mirror://apache/avro/avro-${version}/cpp/avro-cpp-${version}.tar.gz";
    hash = "sha256-+6JCrvd+yBnQdWH8upN1FyGVbejQyujh8vMAtUszG64=";
  };
  patches = [
    # This patch fixes boost compatibility and can be removed when
    # upgrading beyond 1.11.3 https://github.com/apache/avro/pull/1920
    (fetchpatch {
      name = "fix-boost-compatibility.patch";
      url = "https://github.com/apache/avro/commit/016323828f147f185d03f50d2223a2f50bfafce1.patch";
      hash = "sha256-hP/5J2JzSplMvg8EjEk98Vim8DfTyZ4hZ/WGiVwvM1A=";
    })
  ];
  patchFlags = [ "-p3" ];

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ boost ];

  preConfigure = ''
    substituteInPlace test/SchemaTests.cc --replace "BOOST_CHECKPOINT" "BOOST_TEST_CHECKPOINT"
    substituteInPlace test/buffertest.cc --replace "BOOST_MESSAGE" "BOOST_TEST_MESSAGE"
  '';

  meta = {
    description = "A C++ library which implements parts of the Avro Specification";
    homepage = "https://avro.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rasendubi ];
    platforms = lib.platforms.all;
  };
}
