{ stdenv, targetPackages, windows, gcc-prebuilt, component, hostPlatform, targetPlatform
, gmp, mpfr, libmpc, gcc, extraBuildInputs ? [] }:

with stdenv.lib;

let version = "7.3.0";
in stdenv.mkDerivation ({

  name = "gcc-${version}-${component}" + optionalString (targetPlatform != hostPlatform) "-${targetPlatform.config}";

  buildInputs = extraBuildInputs ++ [
    gcc-prebuilt
    gmp mpfr libmpc
  ];

  src = "${gcc-prebuilt}/prebuilt.tar.gz";
  # prebuilt doesn't have a root directory.
  setSourceRoot = "sourceRoot=`pwd`";

  # We'll need to replace all the paths to the prebuilt version
  # with the current $out as the prefix.  We also need to injet
  # -B to the mingw_w64/lib folder so we find libcrt2.o and
  # the other windows libraires (libmvcrt, ...).  Adding -L
  # would not help gcc find libcrt2.o.
  #
  # For pthread support also need to inject the include and lib
  # dirs.  Ideally this would be handled by the cc-wrapper. But
  # we still use the build cc here.
  #
  # TODO: the linking of the mingw_w64_headers into $out/mingw
  #       is rather annoying but gcc currently expect them there.
  #       Ideally I'd like to link them into `mingw` in the
  #       libc (windows.mingw_w64).
  postPatch = ''
    echo "rewriting prefix from ${gcc-prebuilt} -> $out"
    find . \( -name mkheaders\* -o -name Makefile \) -exec \
      sed -i -e "s|${gcc-prebuilt}|$out|g" {} \;
  '' + optionalString (component != "gcc") ''
    sed -i -e 's|SYSROOT_CFLAGS_FOR_TARGET = |SYSROOT_CFLAGS_FOR_TARGET = -B${windows.mingw_w64}/lib -I${windows.mingw_w64_pthreads}/include -L${windows.mingw_w64_pthreads}/lib|g' build/Makefile
    mkdir -p $out && ln -s ${windows.mingw_w64_headers} $out/mingw
  '';

  # don't fail with: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
  hardeningDisable = [ "format" ];
  enableParallelBuilding = true; #(component == "gcc"); #true;

  # We've already done the treewide configure
  # in the gcc-prebuilt.
  configurePhase = ''
    echo "configure disabled"
  '';
  dontStrip = true;

  # the -prebuilt tarball contains `gcc-X.Y` and `build`
  # which is the out of tree build directory for gcc.
  # So we'll change into it prior to buildinging/installing.
  preBuild = ''
    cd build
  '';

  makeFlags = [ "all-${component}" ];
  installTargets = "install-${component}";
} // optionalAttrs (component == "gcc") {
    # gcc has already been built by the -prebuilt step.
    # as such, we don't need to rebuild it here.
    # Maybe we can skip this hack, and just run make
    # it should be a no-op mostly anyway, and would
    # simplify the expression.
    buildPhase = "";
})
