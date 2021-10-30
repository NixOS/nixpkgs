{ lib, stdenv
, fetchurl
, autoreconfHook
, jre
, openssl
, pkg-config
# We depend on ZooKeeper for the Jute compiler.
, zookeeper
}:

stdenv.mkDerivation rec {
  pname = "zookeeper_mt";
  version = lib.getVersion zookeeper;

  src = fetchurl {
    url = "mirror://apache/zookeeper/${zookeeper.pname}-${version}/apache-${zookeeper.pname}-${version}.tar.gz";
    sha512 = "90643aa0ae1b9bf1f5e137dfbcee7e3c53db15e5038d7e406e4a1c345d6a0531bf7afa2b03f99d419ebd0fe892f127a7abfe582f786034ba823e53a0a9246bfb";
  };

  sourceRoot = "apache-${zookeeper.pname}-${version}/zookeeper-client/zookeeper-client-c";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    jre
  ];

  buildInputs = [
    openssl
    zookeeper
  ];

  # Generate the C marshallers/unmarshallers for the Jute-encoded
  # definitions.
  preConfigure = ''
    mkdir generated
    cd generated
    java -cp ${zookeeper}/lib/${zookeeper.pname}-jute-${version}.jar \
        org.apache.jute.compiler.generated.Rcc -l c \
        ../../../zookeeper-jute/src/main/resources/zookeeper.jute
    cd ..
  '';

  configureFlags = [
    # We're not going to start test servers in the sandbox anyway.
    "--without-cppunit"
  ];

  meta = with lib; {
    homepage = "https://zookeeper.apache.org";
    description = "Apache Zookeeper";
    license = licenses.asl20;
    maintainers = with maintainers; [ commandodev ztzg ];
    platforms = platforms.unix;
  };
}
