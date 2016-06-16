{ stdenv, fetchFromGitHub , autoreconfHook, zlib, gmock }:

stdenv.mkDerivation rec {
  name = "protobuf-${version}";

  version = "3.0.0-beta-3.1";
  # make sure you test also -A pythonPackages.protobuf
  src = fetchFromGitHub {
    owner = "google";
    repo = "protobuf";
    rev = "v${version}";
    sha256 = "1lj3q1wq821q9h2y2hhbnvyy4nw3gl0x2g0kplyvd6ivrissfcqx";
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
