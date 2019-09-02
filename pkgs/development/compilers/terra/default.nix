{ stdenv, fetchFromGitHub, fetchurl, llvmPackages, ncurses, lua }:

let
  luajitArchive = "LuaJIT-2.0.5.tar.gz";
  luajitSrc = fetchurl {
    url = "http://luajit.org/download/${luajitArchive}";
    sha256 = "0yg9q4q6v028bgh85317ykc9whgxgysp76qzaqgq55y6jy11yjw7";
  };
in

stdenv.mkDerivation rec {
  pname = "terra-git";
  version = "1.0.0-beta1";

  src = fetchFromGitHub {
    owner = "zdevito";
    repo = "terra";
    rev = "release-${version}";
    sha256 = "1blv3mbmlwb6fxkck6487ck4qq67cbwq6s1zlp86hy2wckgf8q2c";
  };

  outputs = [ "bin" "dev" "out" "static" ];

  postPatch = ''
    substituteInPlace Makefile --replace \
      '-lcurses' '-lncurses'
  '';

  preBuild = ''
    cat >Makefile.inc<<EOF
    CLANG = ${stdenv.lib.getBin llvmPackages.clang-unwrapped}/bin/clang
    LLVM_CONFIG = ${stdenv.lib.getBin llvmPackages.llvm}/bin/llvm-config
    EOF

    mkdir -p build
    cp ${luajitSrc} build/${luajitArchive}
  '';

  installPhase = ''
    install -Dm755 -t $bin/bin release/bin/terra
    install -Dm755 -t $out/lib release/lib/terra${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm644 -t $static/lib release/lib/libterra.a

    mkdir -pv $dev/include
    cp -rv release/include/terra $dev/include
  '';

  buildInputs = with llvmPackages; [ lua llvm clang-unwrapped ncurses ];

  meta = with stdenv.lib; {
    description = "A low-level counterpart to Lua";
    homepage = http://terralang.org/;
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
  };
}
