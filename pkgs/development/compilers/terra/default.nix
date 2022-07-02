{ lib, stdenv, fetchFromGitHub, llvmPackages, ncurses, cmake, libxml2
, symlinkJoin, breakpointHook, cudaPackages, enableCUDA ? false }:

let
  luajitRev = "9143e86498436892cb4316550be4d45b68a61224";
  luajitBase = "LuaJIT-${luajitRev}";
  luajitArchive = "${luajitBase}.tar.gz";
  luajitSrc = fetchFromGitHub {
    owner = "LuaJIT";
    repo = "LuaJIT";
    rev = luajitRev;
    sha256 = "1zw1yr0375d6jr5x20zvkvk76hkaqamjynbswpl604w6r6id070b";
  };

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
  version = "1.0.0-beta5";

  src = fetchFromGitHub {
    owner = "terralang";
    repo = "terra";
    rev = "bcc5a81649cb91aaaff33790b39c87feb5f7a4c2";
    sha256 = "0jb147vbvix3zvrq6ln321jdxjgr6z68pdrirjp4zqmx78yqlcx3";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmMerged ncurses libxml2 ] ++ lib.optional enableCUDA cuda;

  cmakeFlags = [
    "-DHAS_TERRA_VERSION=0"
    "-DTERRA_VERSION=${version}"
    "-DTERRA_LUA=luajit"
    "-DCLANG_RESOURCE_DIR=${llvmMerged}/lib/clang/${clangVersion}"
  ] ++ lib.optional enableCUDA "-DTERRA_ENABLE_CUDA=ON";

  doCheck = true;
  hardeningDisable = [ "fortify" ];
  outputs = [ "bin" "dev" "out" "static" ];

  patches = [ ./nix-cflags.patch ];

  postPatch = ''
    sed -i '/file(DOWNLOAD "''${LUAJIT_URL}" "''${LUAJIT_TAR}")/d' \
      cmake/Modules/GetLuaJIT.cmake

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
    broken = stdenv.isDarwin;
    description = "A low-level counterpart to Lua";
    homepage = "https://terralang.org/";
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ jb55 seylerius thoughtpolice elliottslaughter ];
    license = licenses.mit;
  };
}
