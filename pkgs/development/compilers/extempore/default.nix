{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  writeText,
  cmake,
  pkg-config,
  pcre,
  libuv,
  portaudio,
  boost,
  zlib,
  python3,
  libffi,
  xorg,
  mesa, # Mesa for OpenGL support
  libGL, # Added explicit libGL dependency
}:
let
  llvm-patch = writeText "llvm-3.8.0-extempore.patch" ''
    --- lib/AsmParser/LLParser.cpp	2015-12-21 09:07:14.000000000 -0500
    +++ lib/AsmParser/LLParser.cpp	2016-04-11 13:38:21.988165739 -0400
    @@ -1835,8 +1835,14 @@
         // If the type hasn't been defined yet, create a forward definition and
         // remember where that forward def'n was seen (in case it never is defined).
         if (!Entry.first) {
    -      Entry.first = StructType::create(Context, Lex.getStrVal());
    -      Entry.second = Lex.getLoc();
    +      // this here for extempore
    +      if (M->getTypeByName(Lex.getStrVal())) {
    +        Entry.first = M->getTypeByName(Lex.getStrVal());
    +        Entry.second = SMLoc();
    +      } else {
    +        Entry.first = StructType::create(Context, Lex.getStrVal());
    +        Entry.second = Lex.getLoc();
    +      }
         }
         Result = Entry.first;
         Lex.Lex();
    --- lib/ExecutionEngine/MCJIT/MCJIT.cpp	2015-11-05 14:24:56.000000000 -0500
    +++ lib/ExecutionEngine/MCJIT/MCJIT.cpp	2016-04-11 13:39:15.556164550 -0400
    @@ -529,6 +529,15 @@
             rv.IntVal = APInt(32, PF(ArgValues[0].IntVal.getZExtValue()));
             return rv;
           }
    +      if (FTy->getNumParams() == 1 &&
    +          RetTy->isVoidTy() &&
    +          FTy->getParamType(0)->isPointerTy()) {
    +        GenericValue rv;
    +        void (*PF)(char *) = (void(*)(char *))FPtr;
    +        char* mzone = (char*) GVTOP(ArgValues[0]);
    +        PF(mzone);
    +        return rv;
    +      }
           break;
         }
       }
    --- include/llvm/IR/ValueMap.h	2015-08-04 00:30:24.000000000 +0200
    +++ include/llvm/IR/ValueMap.h	2018-07-14 21:09:09.769502736 +0200
    @@ -99,7 +99,7 @@
       explicit ValueMap(const ExtraData &Data, unsigned NumInitBuckets = 64)
           : Map(NumInitBuckets), Data(Data) {}

    -  bool hasMD() const { return MDMap; }
    +  bool hasMD() const { return static_cast<bool>(MDMap); }
       MDMapT &MD() {
         if (!MDMap)
           MDMap.reset(new MDMapT);
  '';

  llvm-patched = stdenv.mkDerivation {
    pname = "llvm";
    version = "3.8.0";

    src = fetchurl {
      url = "https://releases.llvm.org/3.8.0/llvm-3.8.0.src.tar.xz";
      hash = "sha256-VVsCjp7g9kRf+PlJ6hDpzYvg0ISEDiH7vh0x1R/AbkY=";
    };

    patches = [ llvm-patch ];
    patchFlags = [ "-p0" ];

    nativeBuildInputs = [
      cmake
      pkg-config
      python3
    ];
    buildInputs = [
      zlib
      libffi
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DLLVM_BUILD_LLVM_DYLIB=ON"
      "-DPYTHON_EXECUTABLE=${python3}/bin/python3"
      "-DLLVM_ENABLE_RTTI=ON"
      "-DLLVM_ENABLE_FFI=ON"
      "-DLLVM_ENABLE_TERMINFO=OFF"
      "-DLLVM_TARGETS_TO_BUILD=X86"
    ];

    configurePhase = ''
      runHook preConfigure
      mkdir -p build
      cd build
      cmake $cmakeFlags $PWD/.. -DCMAKE_INSTALL_PREFIX=$out
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      make -j$NIX_BUILD_CORES
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      make install
      mkdir -p $out/src
      cd ..
      cp -r . $out/src/
      cd $out
      tar -czf $out/llvm-3.8.0.src-patched-for-extempore.tar.xz src/*
      rm -rf $out/src
      runHook postInstall
    '';

    enableParallelBuilding = true;
  };

in
stdenv.mkDerivation rec {
  pname = "extempore";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "digego";
    repo = "extempore";
    rev = "v${version}";
    hash = "sha256-mtJYxLxcx7pwi82Dl1yV4tUtvkdJeC84mF+NhUZTBj8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    llvm-patched
    pcre
    libuv
    portaudio
    boost
    zlib
    mesa
    libGL # Added explicit libGL dependency
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.libXi
    xorg.libXinerama
    xorg.xorgproto
    xorg.libXcursor
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXrender
  ];

  cmakeFlags = [
    "-DLLVM_DIR=${llvm-patched}"
    "-DEXT_TERM_SUPPORT=ON"
    "-DCMAKE_INSTALL_PREFIX=$out"
  ];

  # Added NIX_CFLAGS_COMPILE to include OpenGL headers
  NIX_CFLAGS_COMPILE = "-I${libGL.dev}/include";

  enableParallelBuilding = true;

  meta = {
    description = "A cyber-physical programming environment for live coding";
    homepage = "https://extemporelang.github.io/";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.qxrein ];
    platforms = lib.platforms.unix;
    mainProgram = "extempore";
  };
}
