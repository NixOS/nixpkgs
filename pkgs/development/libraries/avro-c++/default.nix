{ stdenv, fetchurl, cmake, boost155, pythonPackages
}:

let version = "1.7.5"; in

stdenv.mkDerivation {
  name = "avro-c++-${version}";

  src = fetchurl {
    url = "mirror://apache/avro/avro-${version}/cpp/avro-cpp-${version}.tar.gz";
    sha256 = "064ssbbgrc3hyalzj8rn119bsrnyk1vlpkhl8gghv96jgqbpdyb3";
  };

  buildInputs = [
    cmake
    boost155
    pythonPackages.python
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A C++ library which implements parts of the Avro Specification";
    homepage = https://avro.apache.org/;
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ rasendubi ];
    platforms = stdenv.lib.platforms.all;
  };
}
