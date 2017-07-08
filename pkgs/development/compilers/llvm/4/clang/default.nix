{ stdenv, fetch, cmake, libxml2, libedit, llvm, version, release_version, clang-tools-extra_src, python
, fixDarwinDylibNames
, enableManpages ? false
}:

let
  gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
  self = stdenv.mkDerivation {
    name = "clang-${version}";

    unpackPhase = ''
      unpackFile ${fetch "cfe" "16vnv3msnvx33dydd17k2cq0icndi1a06bg5vcxkrhjjb1rqlwv1"}
      mv cfe-${version}* clang
      sourceRoot=$PWD/clang
      unpackFile ${clang-tools-extra_src}
      mv clang-tools-extra-* $sourceRoot/tools/extra
    '';

    nativeBuildInputs = [ cmake python ]
      ++ stdenv.lib.optional enableManpages python.pkgs.sphinx;

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

    postBuild = stdenv.lib.optionalString enableManpages ''
      cmake --build . --target docs-clang-man
    '';

    postPatch = ''
      sed -i -e 's/Args.hasArg(options::OPT_nostdlibinc)/true/' lib/Driver/Tools.cpp
      sed -i -e 's/DriverArgs.hasArg(options::OPT_nostdlibinc)/true/' lib/Driver/ToolChains.cpp

      # Patch for standalone doc building
      sed -i '1s,^,find_package(Sphinx REQUIRED)\n,' docs/CMakeLists.txt
    '';

    outputs = [ "out" "python" ]
      ++ stdenv.lib.optional enableManpages "man";

    # Clang expects to find LLVMgold in its own prefix
    # Clang expects to find sanitizer libraries in its own prefix
    postInstall = ''
      ln -sv ${llvm}/lib/LLVMgold.so $out/lib
      ln -sv ${llvm}/lib/clang/${release_version}/lib $out/lib/clang/${release_version}/
      ln -sv $out/bin/clang $out/bin/cpp

      mkdir -p $python/bin $python/share/clang/
      mv $out/bin/{git-clang-format,scan-view} $python/bin
      if [ -e $out/bin/set-xcode-analyzer ]; then
        mv $out/bin/set-xcode-analyzer $python/bin
      fi
      mv $out/share/clang/*.py $python/share/clang

      rm $out/bin/c-index-test
    ''
    + stdenv.lib.optionalString enableManpages ''
      # Manually install clang manpage
      cp docs/man/*.1 $out/share/man/man1/

      # Move it and other man pages to 'man' output
      moveToOutput "share/man" "$man"
    '';

    enableParallelBuilding = true;

    passthru = {
      lib = self; # compatibility with gcc, so that `stdenv.cc.cc.lib` works on both
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
  };
in self
