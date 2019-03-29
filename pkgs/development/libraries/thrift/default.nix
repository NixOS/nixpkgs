{ stdenv, fetchurl, boost, zlib, libevent, openssl, python, pkgconfig, bison
, flex, twisted
}:

stdenv.mkDerivation rec {
  name = "thrift-${version}";
  version = "0.12.0";

  src = fetchurl {
    url = "https://archive.apache.org/dist/thrift/${version}/${name}.tar.gz";
    sha256 = "0a04v7dgm1qzgii7v0sisnljhxc9xpq2vxkka60scrdp6aahjdn3";
  };

  #enableParallelBuilding = true; problems on hydra

  # Workaround to make the python wrapper not drop this package:
  # pythonFull.buildEnv.override { extraLibs = [ thrift ]; }
  pythonPath = [];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    boost zlib libevent openssl python bison flex twisted
  ];

  preConfigure = "export PY_PREFIX=$out";

  # TODO: package boost-test, so we can run the test suite. (Currently it fails
  # to find libboost_unit_test_framework.a.)
  configureFlags = [ "--enable-tests=no" ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Library for scalable cross-language services";
    homepage = http://thrift.apache.org/;
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
