{ stdenv, fetch, cmake, libxml2, libedit, llvm, version, release_version, clang-tools-extra_src, python3
, fixDarwinDylibNames
, enableManpages ? false
}:

let
  gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
  self = stdenv.mkDerivation ({
    name = "clang-${version}";

    unpackPhase = ''
      unpackFile ${fetch "cfe" "1zyh4dggxd55lnfg73c8fybnkssqcaa6bq2h4bzimnnj1jdnqpqk"}
      mv cfe-${version}* clang
      sourceRoot=$PWD/clang
      unpackFile ${clang-tools-extra_src}
      mv clang-tools-extra-* $sourceRoot/tools/extra
    '';

    nativeBuildInputs = [ cmake python3 ]
      ++ stdenv.lib.optional enableManpages python3.pkgs.sphinx;

    buildInputs = [ libedit libxml2 llvm ]
      ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

    cmakeFlags = [
      "-DCMAKE_CXX_FLAGS=-std=c++11"
    ] ++ stdenv.lib.optionals enableManpages [
      "-DCLANG_INCLUDE_DOCS=ON"
      "-DLLVM_ENABLE_SPHINX=ON"
      "-DSPHINX_OUTPUT_MAN=ON"
      "-DSPHINX_OUTPUT_HTML=OFF"
      "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
    ]
    # Maybe with compiler-rt this won't be needed?
    ++ stdenv.lib.optional stdenv.isLinux "-DGCC_INSTALL_PREFIX=${gcc}"
    ++ stdenv.lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${stdenv.cc.libc}/include";

    patches = [ ./purity.patch ];

    postPatch = ''
      sed -i -e 's/DriverArgs.hasArg(options::OPT_nostdlibinc)/true/' \
             -e 's/Args.hasArg(options::OPT_nostdlibinc)/true/' \
             lib/Driver/ToolChains/*.cpp

      # Patch for standalone doc building
      sed -i '1s,^,find_package(Sphinx REQUIRED)\n,' docs/CMakeLists.txt
    '';

    outputs = [ "out" "lib" "python" ];

    # Clang expects to find LLVMgold in its own prefix
    # Clang expects to find sanitizer libraries in its own prefix
    postInstall = ''
      ln -sv ${llvm}/lib/LLVMgold.so $out/lib
      ln -sv ${llvm}/lib/clang/${release_version}/lib $out/lib/clang/${release_version}/
      ln -sv $out/bin/clang $out/bin/cpp

      # Move libclang to 'lib' output
      moveToOutput "lib/libclang.*" "$lib"
      substituteInPlace $out/lib/cmake/clang/ClangTargets-release.cmake \
          --replace "\''${_IMPORT_PREFIX}/lib/libclang." "$lib/lib/libclang."

      mkdir -p $python/bin $python/share/clang/
      mv $out/bin/{git-clang-format,scan-view} $python/bin
      if [ -e $out/bin/set-xcode-analyzer ]; then
        mv $out/bin/set-xcode-analyzer $python/bin
      fi
      mv $out/share/clang/*.py $python/share/clang
      rm $out/bin/c-index-test
    '';

    enableParallelBuilding = true;

    passthru = {
      isClang = true;
      inherit llvm;
    } // stdenv.lib.optionalAttrs stdenv.isLinux {
      inherit gcc;
    };

    meta = {
      description = "A c, c++, objective-c, and objective-c++ frontend for the llvm compiler";
      homepage    = http://llvm.org/;
      license     = stdenv.lib.licenses.ncsa;
      platforms   = stdenv.lib.platforms.all;
    };
  } // stdenv.lib.optionalAttrs enableManpages {
    name = "clang-manpages-${version}";

    buildPhase = ''
      make docs-clang-man
    '';

    installPhase = ''
      mkdir -p $out/share/man/man1
      # Manually install clang manpage
      cp docs/man/*.1 $out/share/man/man1/
    '';

    outputs = [ "out" ];

    doCheck = false;

    meta.description = "man page for Clang ${version}";
  });
in self
