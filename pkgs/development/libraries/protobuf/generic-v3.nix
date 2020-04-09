{ stdenv, fetchFromGitHub, lib
, zlib, cmake, gmock
, version, sha256
, ...
}:
stdenv.mkDerivation rec {
  # make sure you test also -A pythonPackages.protobuf
  pname = "protobuf";
  inherit version;
  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf";
    rev = "v${version}";
    inherit sha256;
  };

  patches =
    [ ./protobuf-cmake.patch ]
    # In version 3.6.X,
    # CMake doesn't generate the version.rc file from version.rc.in.
    ++ lib.optional
       (lib.versionAtLeast version "3.6" && lib.versionOlder version "3.7")
       ./protobuf-3.6-cmake-versionrc.patch;

  postPatch = 
    (if lib.versionAtLeast version "3.6.0"
     then ''
       rm -rf third_party/googletest
       cp -a ${gmock.src} third_party/googletest
       chmod -R a+w third_party/googletest
       ''
     else ''
     cp -a ${gmock.src}/googlemock gmock
     cp -a ${gmock.src}/googletest googletest
     chmod -R a+w gmock
     chmod -R a+w googletest
     ln -s ../googletest gmock/gtest
     '')
    + lib.optionalString stdenv.isDarwin ''
      substituteInPlace src/google/protobuf/testing/googletest.cc \
      --replace 'tmpnam(b)' '"'$TMPDIR'/foo"'
      '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  enableParallelBuilding = true;
  doCheck = true;

  dontDisableStatic = true;

  cmakeDir = "../cmake";

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
    maintainers = [ lib.maintainers.eamsden ];
  };

}

