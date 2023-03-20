{ stdenv
, lib
, fetchFromGitHub
, groff
, cmake
, python2
, perl
, libffi
, libbfd
, libxml2
, valgrind
, ncurses
, zlib
}:

stdenv.mkDerivation {
  pname = "llvm";
  version = "3.6-mono-2017-02-15";

  src = fetchFromGitHub {
    owner = "mono";
    repo = "llvm";
    rev = "dbb6fdffdeb780d11851a6be77c209bd7ada4bd3";
    sha256 = "07wd1cs3fdvzb1lv41b655z5zk34f47j8fgd9ljjimi5j9pj71f7";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ perl groff libxml2 python2 libffi ] ++ lib.optional stdenv.isLinux valgrind;

  propagatedBuildInputs = [ ncurses zlib ];

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';
  postBuild = "rm -fR $out";

  cmakeFlags = with stdenv; [
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
  ] ++ lib.optional (!isDarwin) "-DBUILD_SHARED_LIBS=ON";

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies - Mono build";
    homepage    = "http://llvm.org/";
    license     = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms   = lib.platforms.all;
  };
}
