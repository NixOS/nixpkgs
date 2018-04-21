{ stdenv, fetchFromGitHub, cmake, llvmPackages, libxml2 }:

stdenv.mkDerivation rec {
  version = "0.2.0";
  name = "zig-${version}";

  src = fetchFromGitHub {
    owner = "zig-lang";
    repo = "zig";
    rev = "${version}";
    sha256 = "0lym28z9mj6hfiq78x1fsd8y89h8xyfc1jgqyazi1g9r72427n07";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmPackages.clang-unwrapped llvmPackages.llvm libxml2 ];

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
    homepage = https://ziglang.org/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}
