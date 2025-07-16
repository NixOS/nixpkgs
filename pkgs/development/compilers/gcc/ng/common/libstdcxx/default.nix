{
  lib,
  stdenv,
  gcc_meta,
  release_version,
  version,
  getVersionFile,
  monorepoSrc ? null,
  runCommand,
  autoreconfHook269,
  gettext,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libstdcxx";
  inherit version;

  src = monorepoSrc;

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook269
    gettext
  ];

  patches = [
    (getVersionFile "gcc/custom-threading-model.patch")
  ];

  postUnpack = ''
    mkdir -p ./build
    buildRoot=$(readlink -e "./build")
  '';

  preAutoreconf = ''
    sourceRoot=$(readlink -e "./libstdc++-v3")
    cd $sourceRoot
  '';

  postPatch = ''
    sed -i \
      -e 's/AM_ENABLE_MULTILIB(/AM_ENABLE_MULTILIB(NOPE/' \
      -e 's#glibcxx_toolexeclibdir=no#glibcxx_toolexeclibdir=${builtins.placeholder "out"}/libexec#' \
      configure.ac
  '';

  preConfigure = ''
    cd "$buildRoot"
    configureScript=$sourceRoot/configure
    chmod +x "$configureScript"
  '';

  configureFlags = [
    "--disable-dependency-tracking"
    "--with-toolexeclibdir=${builtins.placeholder "out"}/lib"
    "gcc_cv_target_thread_file=posix"
    "cross_compiling=true"
    "--disable-multilib"

    "--enable-clocale=gnu"
    "--disable-libstdcxx-pch"
    "--disable-vtable-verify"
    "--enable-libstdcxx-visibility"
    "--with-default-libstdcxx-abi=new"
  ];

  outputs = [
    "out"
    "dev"
  ];

  hardeningDisable = [
    # PATH_MAX
    "fortify"
  ];

  doCheck = true;

  passthru = {
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/onlinedocs/libstdc++";
    description = "GNU C++ Library";
  };
})
