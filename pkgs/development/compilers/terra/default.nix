{ lib, stdenv, fetchurl, fetchFromGitHub, llvmPackages, ncurses, cmake, libxml2
, symlinkJoin, breakpointHook, cudaPackages, enableCUDA ? false }:

let
  luajitRev = "9143e86498436892cb4316550be4d45b68a61224";
  luajitArchive = "LuaJIT-${luajitRev}.tar.gz";
  luajitSrc = fetchurl {
    url = "https://github.com/LuaJIT/LuaJIT/archive/${luajitRev}.tar.gz";
    sha256 = "0kasmyk40ic4b9dwd4wixm0qk10l88ardrfimwmq36yc5dhnizmy";
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
in stdenv.mkDerivation rec {
  pname = "terra";
  version = "1.0.0-beta3";

  src = fetchFromGitHub {
    owner = "terralang";
    repo = "terra";
    rev = "release-${version}";
    sha256 = "15ik32xnwyf3g57jvvaz24f6a18lv3a86341rzjbs30kd5045qzd";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmMerged ncurses libxml2 ] ++ lib.optional enableCUDA cuda;

  cmakeFlags = [
    "-DHAS_TERRA_VERSION=0"
    "-DTERRA_VERSION=${src.rev}"
    "-DTERRA_LUA=luajit"
  ] ++ lib.optional enableCUDA "-DTERRA_ENABLE_CUDA=ON";

  doCheck = true;
  enableParallelBuilding = true;
  hardeningDisable = [ "fortify" ];
  outputs = [ "bin" "dev" "out" "static" ];

  patches = [
    # Should be removed as https://github.com/terralang/terra/pull/496 get merged and released.
    ./get-compiler-from-envvar-fix-cpu-detection.patch
    ./nix-cflags.patch
    ./disable-luajit-file-download.patch
    ./nix-add-test-paths.patch
  ];

  INCLUDE_PATH = "${llvmMerged}/lib/clang/10.0.1/include";

  postPatch = ''
    substituteInPlace src/terralib.lua \
      --subst-var-by NIX_LIBC_INCLUDE ${lib.getDev stdenv.cc.libc}/include

    substituteInPlace src/CMakeLists.txt \
      --subst-var INCLUDE_PATH
  '';

  preConfigure = ''
    mkdir -p build
    cp ${luajitSrc} build/${luajitArchive}
  '';

  installPhase = ''
    install -Dm755 -t $bin/bin bin/terra
    install -Dm755 -t $out/lib lib/terra${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm644 -t $static/lib lib/libterra_s.a

    mkdir -pv $dev/include
    cp -rv include/terra $dev/include
  '';

  meta = with lib; {
    description = "A low-level counterpart to Lua";
    homepage = "http://terralang.org/";
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ jb55 seylerius thoughtpolice ];
    license = licenses.mit;
  };
}
