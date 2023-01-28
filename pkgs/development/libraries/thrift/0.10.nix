{ lib, stdenv, fetchurl, boost, zlib, libevent, openssl, python3, pkg-config, bison
, flex
}:

stdenv.mkDerivation rec {
  pname = "thrift";
  version = "0.10.0";

  src = fetchurl {
    url = "https://archive.apache.org/dist/thrift/${version}/${pname}-${version}.tar.gz";
    sha256 = "02x1xw0l669idkn6xww39j60kqxzcbmim4mvpb5h9nz8wqnx1292";
  };

  #enableParallelBuilding = true; problems on hydra

  # Workaround to make the python wrapper not drop this package:
  # pythonFull.buildEnv.override { extraLibs = [ thrift ]; }
  pythonPath = [];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boost zlib libevent openssl bison flex (python3.withPackages (ps: [ps.twisted]))
  ];

  preConfigure = "export PY_PREFIX=$out";

  # TODO: package boost-test, so we can run the test suite. (Currently it fails
  # to find libboost_unit_test_framework.a.)
  configureFlags = [ "--enable-tests=no" ];
  doCheck = false;

  meta = with lib; {
    description = "Library for scalable cross-language services";
    homepage = "https://thrift.apache.org/";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
    knownVulnerabilities = [
      "CVE-2018-1320"
      "CVE-2018-11798"
      "CVE-2019-0205"
      "CVE-2019-0210"
      "CVE-2020-13949"
    ];
  };
}
