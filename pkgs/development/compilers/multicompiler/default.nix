{ pkgs ? import <nixpkgs> {}
, stdenv
, fetchFromGitHub
, debugVersion ? false
, enableSharedLibraries ? !pkgs.stdenv.isDarwin
}:

let

  fetch = { ver, name, sha256}: fetchFromGitHub {
    owner = "securesystemslab";
    repo = name;
    rev = ver;
    inherit sha256;
    };

  mc_llvm_data = {
    ver = "879d92f";
    name = "multicompiler";
    sha256 = "1lzdpz1x8c9hr86znc5z7dfg53yxwzdxnl2375dcz6ihdq55yv6h";
  };

  mc_clang_data = {
    ver = "ebe9315";
    name = "multicompiler-clang";
    sha256 =  "1cmqapdm1p6kxwlr09ksxjk6ss1l7fx55rm8p7d91cmpxrzm49f3";
  };

  gcc = if pkgs.stdenv.cc.isGNU then pkgs.stdenv.cc.cc else pkgs.stdenv.cc.cc.gcc;

  mvcc = pkgs.stdenv.mkDerivation rec {
    version = "3.5.2";
    name = "multicompiler";

    unpackPhase = ''
      unpackFile ${fetch mc_llvm_data}
      mv ${mc_llvm_data.name}-${mc_llvm_data.ver}-src multicompiler
      chmod -R ug+rw multicompiler
      cd multicompiler/tools
      unpackFile ${fetch mc_clang_data}
      mv ${mc_clang_data.name}-${mc_clang_data.ver}-src clang
      chmod -R ug+rw clang
      cd ..
      '';

    buildInputs = with pkgs; [ cmake libedit libxml2 llvm python perl groff libffi ];

    propagatedBuildInputs = with pkgs; [ ncurses zlib ];

    # hacky fix: created binaries need to be run before installation
    preBuild = ''
      mkdir -p $out/
      ln -sv $PWD/lib $out
    '';

    postBuild = ''
      rm -fR $out
      paxmark m bin/{lli,llvm-rtdyld}

      paxmark m unittests/ExecutionEngine/JIT/JITTests
      paxmark m unittests/ExecutionEngine/MCJIT/MCJITTests
      paxmark m unittests/Support/SupportTests
    '';

    cmakeFlags = with pkgs.stdenv; [
      "-DCMAKE_CXX_FLAGS=-std=c++11"
      "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
      "-DLLVM_BUILD_TESTS=ON"
      "-DLLVM_ENABLE_FFI=ON"
      "-DLLVM_REQUIRES_RTTI=1"
      "-DLLVM_TARGETS_TO_BUILD=X86"
    ] ++ lib.optional enableSharedLibraries
      "-DBUILD_SHARED_LIBS=ON"
      ++ lib.optional (!isDarwin)
      "-DLLVM_BINUTILS_INCDIR=${pkgs.binutils.dev}/include"
      ++ lib.optionals ( isDarwin) [
      "-DCMAKE_CXX_FLAGS=-stdlib=libc++"
      "-DCAN_TARGET_i386=false"
    ] ++
    # Maybe with compiler-rt this won't be needed?
    (lib.optional pkgs.stdenv.isLinux "-DGCC_INSTALL_PREFIX=${gcc}") ++
    (lib.optional (pkgs.stdenv.cc.libc != null) "-DC_INCLUDE_DIRS=${cc.libc}/include");

    patches =
      pkgs.stdenv.lib.optionals (!pkgs.stdenv.isDarwin) [./fix-llvm-config.patch ];

    postPatch = ''
      #sed -i -e 's/Args.hasArg(options::OPT_nostdlibinc)/true/' lib/Driver/Tools.cpp
      #sed -i -e 's/DriverArgs.hasArg(options::OPT_nostdlibinc)/true/' lib/Driver/ToolChains.cpp
    '';

    installPhase = ''
      set -x
      mkdir -p $out/bin
      install -m755 bin/* $out/bin/
      mkdir -p $out/lib
      # install -m644 lib $out/lib
      cp -r lib/* $out/lib/
      # Includes get installed in this odd location because this is
      # where the ccWrap will hard-code the search for them (see
      # pkgs/build-support/cc-wrapper/default.nix setting of libc-cflags).
      incdir=$out/lib/gcc/clang/3.5.2/include-fixed
      # mkdir -p $incdir
      # install -m644 lib/clang/3.5.2/include/*.h $incdir/
      mkdir -p $(dirname $incdir)
      ln -s $out/lib/clang/3.5.2/include $incdir
      set +x
      '';

    # Clang expects to find LLVMgold in its own prefix
    # Clang expects to find sanitizer libraries in its own prefix
    postInstall = ''
      #ln -sv ${pkgs.llvm}/lib/LLVMgold.so $out/lib
      ln -sv $out/lib/clang/${version}/lib $out/lib/clang/${version}/
      ln -sv $out/bin/clang $out/bin/cpp
    '';

    # Provide attributes used by wrapCC (pkgs/build-support/cc-wrapper/default.nix)
    passthru = {
      isClang = true;
    } // pkgs.stdenv.lib.optionalAttrs pkgs.stdenv.isLinux {
      inherit gcc;
    };

    meta = with pkgs.stdenv.lib; {
      description = "LLVM-based compiler to create artificial software diversity to protect software from code-reuse attacks";
      platforms = platforms.all;
      homepage = http://github.com/securesystemslab/multicompiler/;
      license = licenses.ncsa;
      maintainers = [ maintainers.kquick ];
    };
  };

in
pkgs.wrapCCWith {
  name = "cc-wrapper"; # with overridePrefix as well
  cc = mvcc;
  libc = stdenv.cc.libc;
  overridePrefix = "mv";
}
