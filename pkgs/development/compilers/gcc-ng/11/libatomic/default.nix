{ lib, stdenv
, gcc_src, version
, autoreconfHook269
}:

stdenv.mkDerivation rec {
  pname = "libatomic";
  inherit version;

  src = gcc_src;

  patches = [
    ../custom-threading-model.patch
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
    #"--with-threads=posix"
    "cross_compiling=true"
    "--disable-multilib"
  ];
}
