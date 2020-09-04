{ stdenv, fetchurl, cmake, boost, python2 }:

let version = "1.10.0"; in

stdenv.mkDerivation {
  pname = "avro-c++";
  inherit version;

  src = fetchurl {
    url = "mirror://apache/avro/avro-${version}/cpp/avro-cpp-${version}.tar.gz";
    sha256 = "1v09x3qy7drsymfrlr8r6izm6cr8jky18hj6p1ddqnapgjh6y0db";
  };

  buildInputs = [
    cmake
    python2
    boost
  ];

  preConfigure = ''
    substituteInPlace test/SchemaTests.cc --replace "BOOST_CHECKPOINT" "BOOST_TEST_CHECKPOINT"
    substituteInPlace test/buffertest.cc --replace "BOOST_MESSAGE" "BOOST_TEST_MESSAGE"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "A C++ library which implements parts of the Avro Specification";
    homepage = "https://avro.apache.org/";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ rasendubi smunix ];
    platforms = stdenv.lib.platforms.all;
  };
}
