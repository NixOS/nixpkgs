{ stdenv, fetch, cmake, libxml2, libedit, llvm, version, clang-tools-extra_src, python }:

let
  gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
  self = stdenv.mkDerivation {
    name = "clang-${version}";

    unpackPhase = ''
      unpackFile ${fetch "cfe" "1ybcac8hlr9vl3wg8s4v6cp0c0qgqnwprsv85lihbkq3vqv94504"}
      mv cfe-${version}.src clang
      sourceRoot=$PWD/clang
      unpackFile ${clang-tools-extra_src}
      mv clang-tools-extra-* $sourceRoot/tools/extra
    '';

    buildInputs = [ cmake libedit libxml2 llvm python ];

    cmakeFlags = [
      "-DCMAKE_CXX_FLAGS=-std=c++11"
    ] ++
    # Maybe with compiler-rt this won't be needed?
    (stdenv.lib.optional stdenv.isLinux "-DGCC_INSTALL_PREFIX=${gcc}") ++
    (stdenv.lib.optional (stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${stdenv.cc.libc}/include");

    patches = [ ./purity.patch ];

    postPatch = ''
      sed -i -e 's/Args.hasArg(options::OPT_nostdlibinc)/true/' lib/Driver/Tools.cpp
      sed -i -e 's/DriverArgs.hasArg(options::OPT_nostdlibinc)/true/' lib/Driver/ToolChains.cpp
    '';

    outputs = [ "out" "python" ];

    # Clang expects to find LLVMgold in its own prefix
    # Clang expects to find sanitizer libraries in its own prefix
    postInstall = ''
      ln -sv ${llvm}/lib/LLVMgold.so $out/lib
      ln -sv ${llvm}/lib/clang/${version}/lib $out/lib/clang/${version}/
      ln -sv $out/bin/clang $out/bin/cpp

      mkdir -p $python/bin $python/share/clang/
      mv $out/bin/{git-clang-format,scan-view,set-xcode-analyzer} $python/bin
      mv $out/share/clang/*.py $python/share/clang

      rm $out/bin/c-index-test
    '';

    enableParallelBuilding = true;

    passthru = {
      lib = self; # compatibility with gcc, so that `stdenv.cc.cc.lib` works on both
      isClang = true;
    } // stdenv.lib.optionalAttrs stdenv.isLinux {
      inherit gcc;
    };

    meta = {
      description = "A c, c++, objective-c, and objective-c++ frontend for the llvm compiler";
      homepage    = http://llvm.org/;
      license     = stdenv.lib.licenses.bsd3;
      platforms   = stdenv.lib.platforms.all;
    };
  };
in self
