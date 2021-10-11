{ lib, stdenv
, gcc_src, version
, autoreconfHook269, gettext
}:

stdenv.mkDerivation rec {
  pname = "libstdc++-v3";
  inherit version;

  src = gcc_src;

  patches = [
    ../custom-threading-model.patch
    ./disable-multilib-harder.patch
  ];

  outputs = [ "out" "dev" ];

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook269 gettext ];

  enableParallelBuilding = true;

  postPatch = ''
    sourceRoot=$(readlink -e "./${pname}")
    cd $sourceRoot

    sed -i \
      -e 's/AM_ENABLE_MULTILIB(/AM_ENABLE_MULTILIB(NOPE/' \
      -e 's#glibcxx_toolexeclibdir=no#glibcxx_toolexeclibdir=${builtins.placeholder "out" + "/libexec"}#' \
      configure.ac
  '';

  configurePlatforms = [ "build" "host" ];
  configureFlags = [
    "--disable-dependency-tracking"
    "--with-toolexeclibdir=${builtins.placeholder "out" + "/lib"}"
    #"--with-threads=posix"
    "cross_compiling=true"
    "--disable-multilib"

    "--enable-clocale=gnu"
    "--disable-libstdcxx-pch"
    "--disable-vtable-verify"
    "--enable-libstdcxx-visibility"
    "--with-default-libstdcxx-abi=new"
  ] ++ lib.optional stdenv.hostPlatform.isMusl [
    "libat_cv_have_ifunc=no"
  ];
}
