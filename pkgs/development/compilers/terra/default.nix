{ stdenv, fetchurl, fetchFromGitHub
, llvmPackages, ncurses, lua
}:

let
  luajitArchive = "LuaJIT-2.0.5.tar.gz";
  luajitSrc = fetchurl {
    url    = "http://luajit.org/download/${luajitArchive}";
    sha256 = "0yg9q4q6v028bgh85317ykc9whgxgysp76qzaqgq55y6jy11yjw7";
  };
in
stdenv.mkDerivation rec {
  pname = "terra";
  version = "1.0.0pre1175_${builtins.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner  = "zdevito";
    repo   = "terra";
    rev    = "ef6a75ffee15a30f3c74f4e6943851cfbc0fec3d";
    sha256 = "0aky17vbv3d9zng34hp17p9zb00dbzwhvzsdjzrrqvk9lmyvix0s";
  };

  nativeBuildInputs = [ lua ];
  buildInputs = with llvmPackages; [ llvm clang-unwrapped ncurses ];

  doCheck = true;
  enableParallelBuilding = true;
  hardeningDisable = [ "fortify" ];
  outputs = [ "bin" "dev" "out" "static" ];

  patches = [ ./nix-cflags.patch ];
  postPatch = ''
    substituteInPlace Makefile \
      --replace '-lcurses' '-lncurses'

    substituteInPlace src/terralib.lua \
      --subst-var-by NIX_LIBC_INCLUDE ${stdenv.lib.getDev stdenv.cc.libc}/include
  '';

  preBuild = ''
    cat >Makefile.inc<<EOF
    CLANG = ${stdenv.lib.getBin llvmPackages.clang-unwrapped}/bin/clang
    LLVM_CONFIG = ${stdenv.lib.getBin llvmPackages.llvm}/bin/llvm-config
    EOF

    mkdir -p build
    cp ${luajitSrc} build/${luajitArchive}
  '';

  checkPhase = "(cd tests && ../terra run)";

  installPhase = ''
    install -Dm755 -t $bin/bin release/bin/terra
    install -Dm755 -t $out/lib release/lib/terra${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm644 -t $static/lib release/lib/libterra.a

    mkdir -pv $dev/include
    cp -rv release/include/terra $dev/include
  '';

  meta = with stdenv.lib; {
    description = "A low-level counterpart to Lua";
    homepage    = "http://terralang.org/";
    platforms   = platforms.x86_64;
    maintainers = with maintainers; [ jb55 thoughtpolice ];
    license     = licenses.mit;
  };
}
