{ lib, stdenv, fetchFromGitHub, llvmPackages_16, ncurses, cmake, libxml2
, symlinkJoin, cudaPackages, enableCUDA ? false
, libffi, libobjc, libpfm, Cocoa, Foundation
}:

let
  luajitRev = "50936d784474747b4569d988767f1b5bab8bb6d0";
  luajitBase = "LuaJIT-${luajitRev}";
  luajitArchive = "${luajitBase}.tar.gz";
  luajitSrc = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = luajitRev;
    sha256 = "1g87pl014b5v6z2nnhiwn3wf405skawszfr5wdzyfbx00j3kgxd0";
  };

  llvmPackages = llvmPackages_16;
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

  cuda = cudaPackages.cudatoolkit_11;

  clangVersion = llvmPackages.clang-unwrapped.version;

in stdenv.mkDerivation rec {
  pname = "terra";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "terralang";
    repo = "terra";
    rev = "release-${version}";
    sha256 = "0v9vpxcp9ybwnfljskqn41vjq7c0srdfv7qs890a6480pnk4kavd";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmMerged ncurses libffi libxml2 ]
    ++ lib.optionals enableCUDA [ cuda ]
    ++ lib.optional (!stdenv.isDarwin) libpfm
    ++ lib.optionals stdenv.isDarwin [ libobjc Cocoa Foundation ];

  cmakeFlags = let
    resourceDir = "${llvmMerged}/lib/clang/" + (
      if lib.versionOlder clangVersion "16"
      then
        clangVersion
      else
        lib.versions.major clangVersion
    );
  in [
    "-DHAS_TERRA_VERSION=0"
    "-DTERRA_VERSION=${version}"
    "-DTERRA_LUA=luajit"
    "-DTERRA_SKIP_LUA_DOWNLOAD=ON"
    "-DCLANG_RESOURCE_DIR=${resourceDir}"
  ] ++ lib.optional enableCUDA "-DTERRA_ENABLE_CUDA=ON";

  doCheck = true;
  hardeningDisable = [ "fortify" ];
  outputs = [ "bin" "dev" "out" "static" ];

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
    maintainers = with maintainers; [ jb55 seylerius thoughtpolice elliottslaughter ];
    license = licenses.mit;
    # never built on aarch64-darwin since first introduction in nixpkgs
    # Linux Aarch64 broken above LLVM11
    # https://github.com/terralang/terra/issues/597
    broken = stdenv.isAarch64;
  };
}
