{
  lib,
  stdenv,
  fetchFromGitHub,
  llvmPackages_18,
  ncurses,
  cmake,
  libxml2,
  symlinkJoin,
  cudaPackages,
  enableCUDA ? false,
  libffi,
  libpfm,
}:

let
  luajitRev = "83954100dba9fc0cf5eeaf122f007df35ec9a604";
  luajitBase = "LuaJIT-${luajitRev}";
  luajitArchive = "${luajitBase}.tar.gz";
  luajitSrc = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = luajitRev;
    hash = "sha256-L9T6lc32dDLAp9hPI5mKOzT0c4juW9JHA3FJCpm7HNQ=";
  };

  llvmPackages = llvmPackages_18;
  llvmMerged = symlinkJoin {
    name = "llvmClangMerged";
    paths = with llvmPackages; [
      llvm.out
      llvm.dev
      llvm.lib
      clang-unwrapped.out
      clang-unwrapped.dev
      clang-unwrapped.lib
    ];
  };

  cuda = cudaPackages.cudatoolkit;

  clangVersion = llvmPackages.clang-unwrapped.version;

in
stdenv.mkDerivation rec {
  pname = "terra";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "terralang";
    repo = "terra";
    rev = "release-${version}";
    hash = "sha256-CukNCvTHZUhjdHyvDUSH0YCVNkThUFPaeyLepyEKodA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    llvmMerged
    ncurses
    libffi
    libxml2
  ]
  ++ lib.optionals enableCUDA [ cuda ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) libpfm;

  cmakeFlags =
    let
      resourceDir = "${llvmMerged}/lib/clang/${lib.versions.major clangVersion}";
    in
    [
      "-DHAS_TERRA_VERSION=0"
      "-DTERRA_VERSION=${version}"
      "-DTERRA_LUA=luajit"
      "-DTERRA_SKIP_LUA_DOWNLOAD=ON"
      "-DCLANG_RESOURCE_DIR=${resourceDir}"
    ]
    ++ lib.optional enableCUDA "-DTERRA_ENABLE_CUDA=ON";

  doCheck = true;
  hardeningDisable = [ "fortify" ];
  outputs = [
    "bin"
    "dev"
    "out"
    "static"
  ];

  patches = [ ./nix-cflags.patch ];

  postPatch = ''
    substituteInPlace src/terralib.lua \
      --subst-var-by NIX_LIBC_INCLUDE ${lib.getDev stdenv.cc.libc}/include
  '';

  preConfigure = ''
    mkdir -p build
    ln -s ${luajitSrc} build/${luajitBase}
    tar --mode="a+rwX" -chzf build/${luajitArchive} -C build ${luajitBase}
    rm build/${luajitBase}
  '';

  installPhase = ''
    install -Dm755 -t $bin/bin bin/terra
    install -Dm755 -t $out/lib lib/terra${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm644 -t $static/lib lib/libterra_s.a

    mkdir -pv $dev/include
    cp -rv include/terra $dev/include
  '';

  meta = with lib; {
    description = "Low-level counterpart to Lua";
    homepage = "https://terralang.org/";
    platforms = platforms.all;
    maintainers = with maintainers; [
      jb55
      seylerius
      thoughtpolice
      elliottslaughter
    ];
    license = licenses.mit;
    # never built on aarch64-darwin since first introduction in nixpkgs
    # Linux Aarch64 broken above LLVM11
    # https://github.com/terralang/terra/issues/597
    broken = stdenv.hostPlatform.isAarch64;
  };
}
