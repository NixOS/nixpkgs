{ stdenv
, fetchurl, perl, gcc
, ncurses6, gmp, glibc, libiconv, numactl
, llvmPackages

  # minimal = true; will remove files that aren't strictly necessary for
  # regular builds and GHC bootstrapping.
  # This is "useful" for staying within hydra's output limits for at least the
  # aarch64-linux architecture.
, minimal ? false
}:

# Prebuilt only does native
assert stdenv.targetPlatform == stdenv.hostPlatform;

let
  useLLVM = !stdenv.targetPlatform.isx86;

  libPath = stdenv.lib.makeLibraryPath ([
    ncurses6 gmp
  ] ++ stdenv.lib.optional (stdenv.hostPlatform.isDarwin) libiconv
    ++ stdenv.lib.optional (stdenv.hostPlatform.isAarch64) numactl);

  libEnvVar = stdenv.lib.optionalString stdenv.hostPlatform.isDarwin "DY"
    + "LD_LIBRARY_PATH";

  glibcDynLinker = assert stdenv.isLinux;
    if stdenv.hostPlatform.libc == "glibc" then
       # Could be stdenv.cc.bintools.dynamicLinker, keeping as-is to avoid rebuild.
       ''"$(cat $NIX_CC/nix-support/dynamic-linker)"''
    else
      "${stdenv.lib.getLib glibc}/lib/ld-linux*";

in

stdenv.mkDerivation rec {
  version = "8.10.2";

  name = "ghc-${version}-binary";

  # https://downloads.haskell.org/~ghc/8.10.2/
  src = fetchurl ({
    i686-linux = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-i386-deb9-linux.tar.xz";
      sha256 = "0bvwisl4w0z5z8z0da10m9sv0mhm9na2qm43qxr8zl23mn32mblx";
    };
    x86_64-linux = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-x86_64-deb10-linux.tar.xz";
      sha256 = "0chnzy9j23b2wa8clx5arwz8wnjfxyjmz9qkj548z14cqf13slcl";
    };
    armv7l-linux = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-armv7-deb10-linux.tar.xz";
      sha256 = "1j41cq5d3rmlgz7hzw8f908fs79gc5mn3q5wz277lk8zdf19g75v";
    };
    aarch64-linux = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-aarch64-deb10-linux.tar.xz";
      sha256 = "14smwl3741ixnbgi0l51a7kh7xjkiannfqx15b72svky0y4l3wjw";
    };
    x86_64-darwin = {
      url = "http://haskell.org/ghc/dist/${version}/ghc-${version}-x86_64-apple-darwin.tar.xz";
      sha256 = "1hngyq14l4f950hzhh2d204ca2gfc98pc9xdasxihzqd1jq75dzd";
    };
  }.${stdenv.hostPlatform.system}
    or (throw "cannot bootstrap GHC on this platform"));

  nativeBuildInputs = [ perl ];
  propagatedBuildInputs = stdenv.lib.optionals useLLVM [ llvmPackages.llvm ];

  # Cannot patchelf beforehand due to relative RPATHs that anticipate
  # the final install location/
  ${libEnvVar} = libPath;

  postUnpack =
    # GHC has dtrace probes, which causes ld to try to open /usr/lib/libdtrace.dylib
    # during linking
    stdenv.lib.optionalString stdenv.isDarwin ''
      export NIX_LDFLAGS+=" -no_dtrace_dof"
      # not enough room in the object files for the full path to libiconv :(
      for exe in $(find . -type f -executable); do
        isScript $exe && continue
        ln -fs ${libiconv}/lib/libiconv.dylib $(dirname $exe)/libiconv.dylib
        install_name_tool -change /usr/lib/libiconv.2.dylib @executable_path/libiconv.dylib -change /usr/local/lib/gcc/6/libgcc_s.1.dylib ${gcc.cc.lib}/lib/libgcc_s.1.dylib $exe
      done
    '' +

    # Some scripts used during the build need to have their shebangs patched
    ''
      patchShebangs ghc-${version}/utils/
      patchShebangs ghc-${version}/configure
    '' +
    # We have to patch the GMP paths for the integer-gmp package.
    ''
      find . -name integer-gmp.buildinfo \
          -exec sed -i "s@extra-lib-dirs: @extra-lib-dirs: ${gmp.out}/lib@" {} \;
    '' + stdenv.lib.optionalString stdenv.isDarwin ''
      find . -name base.buildinfo \
          -exec sed -i "s@extra-lib-dirs: @extra-lib-dirs: ${libiconv}/lib@" {} \;
    '' +
    # aarch64 does HAVE_NUMA so -lnuma requires it in library-dirs in rts/package.conf.in
    # FFI_LIB_DIR is a good indication of places it must be needed.
    stdenv.lib.optionalString stdenv.hostPlatform.isAarch64 ''
      find . -name package.conf.in \
          -exec sed -i "s@FFI_LIB_DIR@FFI_LIB_DIR ${numactl.out}/lib@g" {} \;
    '' +
    # Rename needed libraries and binaries, fix interpreter
    stdenv.lib.optionalString stdenv.isLinux ''
      find . -type f -perm -0100 -exec patchelf \
          --replace-needed libncurses${stdenv.lib.optionalString stdenv.is64bit "w"}.so.6 libncurses.so \
          --interpreter ${glibcDynLinker} {} \;

      sed -i "s|/usr/bin/perl|perl\x00        |" ghc-${version}/ghc/stage2/build/tmp/ghc-stage2
      sed -i "s|/usr/bin/gcc|gcc\x00        |" ghc-${version}/ghc/stage2/build/tmp/ghc-stage2
    '' +
    # We're kludging a glibc bindist into working with non-glibc...
    # Here we patch up the use of `__strdup` (part of glibc binary ABI)
    # to instead use `strdup` since musl doesn't provide __strdup
    # (`__strdup` is defined to be an alias of `strdup` anyway[1]).
    # [1] http://refspecs.linuxbase.org/LSB_4.0.0/LSB-Core-generic/LSB-Core-generic/baselib---strdup-1.html
    # Use objcopy magic to make the change:
    stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
      find ./ghc-${version}/rts -name "libHSrts*.a" -exec ''${OBJCOPY:-objcopy} --redefine-sym __strdup=strdup {} \;
    '';

  # fix for `configure: error: Your linker is affected by binutils #16177`
  preConfigure = stdenv.lib.optionalString
    stdenv.targetPlatform.isAarch32
    "LD=ld.gold";

  configurePlatforms = [ ];
  configureFlags = [
    "--with-gmp-libraries=${stdenv.lib.getLib gmp}/lib"
    "--with-gmp-includes=${stdenv.lib.getDev gmp}/include"
  ] ++ stdenv.lib.optional stdenv.isDarwin "--with-gcc=${./gcc-clang-wrapper.sh}"
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl "--disable-ld-override";

  # No building is necessary, but calling make without flags ironically
  # calls install-strip ...
  dontBuild = true;

  # On Linux, use patchelf to modify the executables so that they can
  # find editline/gmp.
  postFixup = stdenv.lib.optionalString stdenv.isLinux
    (if stdenv.hostPlatform.isAarch64 then
      # Keep rpath as small as possible on aarch64 for patchelf#244.  All Elfs
      # are 2 directories deep from $out/lib, so pooling symlinks there makes
      # a short rpath.
      ''
      (cd $out/lib; ln -s ${ncurses6.out}/lib/libtinfo.so.6)
      (cd $out/lib; ln -s ${gmp.out}/lib/libgmp.so.10)
      (cd $out/lib; ln -s ${numactl.out}/lib/libnuma.so.1)
      for p in $(find "$out/lib" -type f -name "*\.so*"); do
        (cd $out/lib; ln -s $p)
      done

      for p in $(find "$out/lib" -type f -executable); do
        if isELF "$p"; then
          echo "Patchelfing $p"
          patchelf --set-rpath "\$ORIGIN:\$ORIGIN/../.." $p
        fi
      done
      ''
    else
      ''
      for p in $(find "$out" -type f -executable); do
        if isELF "$p"; then
          echo "Patchelfing $p"
          patchelf --set-rpath "${libPath}:$(patchelf --print-rpath $p)" $p
        fi
      done
    '') + stdenv.lib.optionalString stdenv.isDarwin ''
    # not enough room in the object files for the full path to libiconv :(
    for exe in $(find "$out" -type f -executable); do
      isScript $exe && continue
      ln -fs ${libiconv}/lib/libiconv.dylib $(dirname $exe)/libiconv.dylib
      install_name_tool -change /usr/lib/libiconv.2.dylib @executable_path/libiconv.dylib -change /usr/local/lib/gcc/6/libgcc_s.1.dylib ${gcc.cc.lib}/lib/libgcc_s.1.dylib $exe
    done

    for file in $(find "$out" -name setup-config); do
      substituteInPlace $file --replace /usr/bin/ranlib "$(type -P ranlib)"
    done
  '' +
  stdenv.lib.optionalString minimal ''
    # Remove profiling files
    find $out -type f -name '*.p_o' -delete
    find $out -type f -name '*.p_hi' -delete
    find $out -type f -name '*_p.a' -delete
    rm $out/lib/ghc-*/bin/ghc-iserv-prof
    # Hydra will redistribute this derivation, so we have to keep the docs for
    # legal reasons (retaining the legal notices etc)
    # As a last resort we could unpack the docs separately and symlink them in.
    # They're in $out/share/{doc,man}.
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    unset ${libEnvVar}
    # Sanity check, can ghc create executables?
    cd $TMP
    mkdir test-ghc; cd test-ghc
    cat > main.hs << EOF
      {-# LANGUAGE TemplateHaskell #-}
      module Main where
      main = putStrLn \$([|"yes"|])
    EOF
    $out/bin/ghc --make main.hs || exit 1
    echo compilation ok
    [ $(./main) == "yes" ]
  '';

  passthru = {
    targetPrefix = "";
    enableShared = true;
  };

  meta = {
    homepage = "http://haskell.org/ghc";
    description = "The Glasgow Haskell Compiler";
    license = stdenv.lib.licenses.bsd3;
    platforms = ["x86_64-linux" "armv7l-linux" "aarch64-linux" "i686-linux" "x86_64-darwin"];
    maintainers = with stdenv.lib.maintainers; [ lostnet ];
  };
}
