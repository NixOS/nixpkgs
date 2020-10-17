{ stdenv
, fetchFromGitHub
, autoreconfHook, zlib, gmock, buildPackages
, version, sha256
, maven, protobuf
, ...
}:

let
mkProtobufDerivation = buildProtobuf: stdenv: stdenv.mkDerivation {
  pname = "protobuf-java";
  inherit version;

  # make sure you test also -A pythonPackages.protobuf
  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf";
    rev = "v${version}";
    inherit sha256;
  };

  # mvn -Dprotoc= doesn't override ant runner plugin vars
  patches = [ ./protoc-java.patch ];

  postPatch = ''
    rm -rf gmock
    cp -r ${gmock.src}/googlemock gmock
    cp -r ${gmock.src}/googletest googletest
    chmod -R a+w gmock
    chmod -R a+w googletest
    ln -s ../googletest gmock/gtest
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/google/protobuf/testing/googletest.cc \
      --replace 'tmpnam(b)' '"'$TMPDIR'/foo"'
  '';

  buildPhase = ''
    cd java
    mkdir $TMPDIR/.m2
    mvn -Dmaven.repo.local=$TMPDIR/.m2 -DskipTests -Dprotoc2=${protobuf}/bin/protoc package -pl core,util,lite
  '';
  installPhase = ''
    mkdir $out
     find . -name "*.jar" -exec cp '{}' $out/ \;
  '';

  nativeBuildInputs = [ maven protobuf ];

  buildInputs = [ zlib ];
  configureFlags = if buildProtobuf == null then [] else [ "--with-protoc=${buildProtobuf}/bin/protoc" ];

  enableParallelBuilding = true;

  doCheck = true;

  dontDisableStatic = true;

  meta = {
    description = "Google's data interchange format";
    longDescription =
      ''Protocol Buffers are a way of encoding structured data in an efficient
        yet extensible format. Google uses Protocol Buffers for almost all of
        its internal RPC protocols and file formats.
      '';
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    homepage = "https://developers.google.com/protocol-buffers/";
  };

  passthru.version = version;
};
in mkProtobufDerivation(if (stdenv.buildPlatform != stdenv.hostPlatform)
                        then (mkProtobufDerivation null buildPackages.stdenv)
                        else null) stdenv
