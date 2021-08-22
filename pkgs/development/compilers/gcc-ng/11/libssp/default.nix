{ lib, stdenv
, gcc_src, version
, autoreconfHook269
}:

stdenv.mkDerivation rec {
  pname = "libssp";
  inherit version;

  src = gcc_src;

  patches = [
    ./fix-include-dir.patch
  ];

  outputs = [ "out" "dev" ];

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook269 ];

  enableParallelBuilding = true;

  postPatch = ''
    sourceRoot=$(readlink -e "./${pname}")
    cd $sourceRoot

    sed -i \
      -e 's/AM_ENABLE_MULTILIB(/AM_ENABLE_MULTILIB(NOPE/' \
      configure.ac
  '';

  configurePlatforms = [ "build" "host" ];
  configureFlags = [
    "--disable-dependency-tracking"
    "--with-toolexeclibdir=${builtins.placeholder "out" + "/lib"}"
    "cross_compiling=true"
    "--disable-multilib"
  ];
}
