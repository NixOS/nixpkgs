{ stdenv
, fetchFromGitHub
, autoreconfHook, zlib, gmock
, version, sha256
, ...
}:

stdenv.mkDerivation rec {
  name = "protobuf-${version}";

  # make sure you test also -A pythonPackages.protobuf
  src = fetchFromGitHub {
    owner = "google";
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
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/google/protobuf/testing/googletest.cc \
      --replace 'tmpnam(b)' '"'$TMPDIR'/foo"'
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  enableParallelBuilding = true;

  doCheck = true;

  dontDisableStatic = true;

  NIX_CFLAGS_COMPILE = with stdenv.lib;
    # gcc before 6 doesn't know this option
    optionalString (hasPrefix "gcc-6" stdenv.cc.cc.name) "-Wno-error=misleading-indentation";

  meta = {
    description = "Google's data interchange format";
    longDescription =
      ''Protocol Buffers are a way of encoding structured data in an efficient
        yet extensible format. Google uses Protocol Buffers for almost all of
        its internal RPC protocols and file formats.
      '';
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
    homepage = https://developers.google.com/protocol-buffers/;
  };

  passthru.version = version;
}
