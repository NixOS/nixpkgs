{ stdenv, fetchFromGitHub , autoreconfHook, zlib, gmock }:

stdenv.mkDerivation rec {
  name = "protobuf-${version}";

  version = "3.0.0-beta-2";
  # make sure you test also -A pythonPackages.protobuf
  src = fetchFromGitHub {
    owner = "google";
    repo = "protobuf";
    rev = "v${version}";
    sha256 = "0cbr1glgma5vakabsjwcs41pcnn8yphhn037l0zd121zb9gdaqc1";
  };

  postPatch = ''
    rm -rf gmock
    cp -r ${gmock.source} gmock
    chmod -R a+w gmock
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/google/protobuf/testing/googletest.cc \
      --replace 'tmpnam(b)' '"'$TMPDIR'/foo"'
  '';

  buildInputs = [ autoreconfHook zlib ];

  enableParallelBuilding = true;

  doCheck = true;

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
