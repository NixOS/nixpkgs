{ stdenv, version, src
, autoreconfHook, zlib, gtest
, ...
}:

stdenv.mkDerivation rec {
  name = "protobuf-${version}";

  inherit src;

  postPatch = ''
    rm -rf gtest
    cp -r ${gtest.source} gtest
    chmod -R a+w gtest
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/google/protobuf/testing/googletest.cc \
      --replace 'tmpnam(b)' '"'$TMPDIR'/foo"'
  '';

  outputs = [ "out" "lib" ];

  buildInputs = [ autoreconfHook zlib ];

  doCheck = true;

  meta = {
    description = "Protocol Buffers - Google's data interchange format";

    longDescription =
      '' Protocol Buffers are a way of encoding structured data in an
         efficient yet extensible format.  Google uses Protocol Buffers for
         almost all of its internal RPC protocols and file formats.
      '';

    license = "mBSD";

    homepage = https://developers.google.com/protocol-buffers/;
  };

  passthru.version = version;
}
