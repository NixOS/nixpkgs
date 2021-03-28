{ lib, stdenv
, fetchFromGitHub
, autoreconfHook, zlib, gmock, buildPackages
, version, sha256
, ...
}:

let
mkProtobufDerivation = buildProtobuf: stdenv: stdenv.mkDerivation {
  pname = "protobuf";
  inherit version;

  # make sure you test also -A pythonPackages.protobuf
  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf";
    rev = "v${version}";
    inherit sha256;
  };

  postPatch = ''
    rm -rf gmock
    cp -r ${gmock.src}/googlemock gmock
    cp -r ${gmock.src}/googletest googletest
    chmod -R a+w gmock
    chmod -R a+w googletest
    ln -s ../googletest gmock/gtest
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/google/protobuf/testing/googletest.cc \
      --replace 'tmpnam(b)' '"'$TMPDIR'/foo"'
  '';

  nativeBuildInputs = [ autoreconfHook buildPackages.which buildPackages.stdenv.cc buildProtobuf ];

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
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    homepage = "https://developers.google.com/protocol-buffers/";
  };

  passthru.version = version;
};
in mkProtobufDerivation(if (stdenv.buildPlatform != stdenv.hostPlatform)
                        then (mkProtobufDerivation null buildPackages.stdenv)
                        else null) stdenv
