{ stdenv, lib, version, src
, autoreconfHook, zlib, gtest
, ...
}:

stdenv.mkDerivation rec {
  name = "protobuf-${version}";

  inherit src;

  postPatch = ''
    rm -rf gtest
    cp -r ${gtest.src}/googletest gtest
    chmod -R a+w gtest
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/google/protobuf/testing/googletest.cc \
      --replace 'tmpnam(b)' '"'$TMPDIR'/foo"'
  '';

  outputs = [ "out" "lib" ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zlib ];

  # The generated C++ code uses static initializers which mutate a global data
  # structure. This causes problems for an executable when:
  #
  # 1) it dynamically links to two libs, both of which contain generated C++ for
  #    the same proto file, and
  # 2) the two aforementioned libs both dynamically link to libprotobuf.
  #
  # One solution is to statically link libprotobuf, that way the global
  # variables are not shared; in fact, this is necessary for the python Mesos
  # binding to not crash, as the python lib contains two C extensions which
  # both refer to the same proto schema.
  #
  # See: https://github.com/NixOS/nixpkgs/pull/19064#issuecomment-255082684
  #      https://github.com/google/protobuf/issues/1489
  dontDisableStatic = true;
  configureFlags = [
    "CFLAGS=-fPIC"
    "CXXFLAGS=-fPIC"
  ];

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
    platforms = stdenv.lib.platforms.unix;
  };

  passthru.version = version;
}
