{ stdenv, fetchFromGitHub, fetchurl, llvmPackages, ncurses, lua }:

let
  luajitArchive = "LuaJIT-2.0.4.tar.gz";
  luajitSrc = fetchurl {
    url = "http://luajit.org/download/${luajitArchive}";
    sha256 = "0zc0y7p6nx1c0pp4nhgbdgjljpfxsb5kgwp4ysz22l1p2bms83v2";
  };
in

stdenv.mkDerivation rec {
  name = "terra-git-${version}";
  version = "2016-06-09";

  src = fetchFromGitHub {
    owner = "zdevito";
    repo = "terra";
    rev = "22696f178be8597af555a296db804dba820638ba";
    sha256 = "1c2i9ih331304bh31c5gh94fx0qa49rsn70pvczvdfhi8pmcms6g";
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
    mkdir -pv $out/lib
    cp -v release/lib/terra.so $out/lib

    mkdir -pv $bin/bin
    cp -v release/bin/terra $bin/bin

    mkdir -pv $static/lib
    cp -v release/lib/libterra.a $static/lib

    mkdir -pv $dev/include
    cp -rv release/include/terra $dev/include
  ''
  ;

  postFixup = ''
    paxmark m $bin/bin/terra
  '';

  buildInputs = with llvmPackages; [ lua llvm clang-unwrapped ncurses ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A low-level counterpart to Lua";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jb55 ];
    license = licenses.mit;
  };
}
