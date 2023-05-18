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
    sha512 = "sha512-ttYbATvfe+uRYhQWfeG1WGXl5GOztcrITfl/4EQierAzSaDvTmVxSb582hYQOdBpxw2QrVbIdnTm3/Xt4ifecg==";
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
