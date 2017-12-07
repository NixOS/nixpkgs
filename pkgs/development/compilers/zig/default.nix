{ stdenv, fetchFromGitHub, cmake, llvmPackages_5, llvm_5 }:

stdenv.mkDerivation rec {
  version = "0.1.1";
  name = "zig-${version}";

  src = fetchFromGitHub {
    owner = "zig-lang";
    repo = "zig";
    rev = "${version}";
    sha256 = "01yqjyi25f99bfmxxwyh45k7j84z0zg7n9jl8gg0draf96mzdh06";
  };

  buildInputs = [ cmake llvmPackages_5.clang-unwrapped llvm_5 ];

  cmakeFlags = [
    "-DZIG_LIBC_INCLUDE_DIR=${stdenv.cc.libc_dev}/include"
    "-DZIG_LIBC_LIB_DIR=${stdenv.cc.libc}/lib"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DZIG_EACH_LIB_RPATH=On"
  ];

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DZIG_LIBC_STATIC_LIB_DIR=$(dirname $(cc -print-file-name=crtbegin.o)) -DZIG_DYNAMIC_LINKER=$(cc -print-file-name=ld-linux-x86-64.so.2)"
  '';

  meta = with stdenv.lib; {
    description = "Programming languaged designed for robustness, optimality, and clarity";
    homepage = http://ziglang.org/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}
