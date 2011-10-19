{ stdenv, fetchurl, perl, groff, llvm }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";
let
  triplet = if (stdenv.system == "i686-linux") then "i686-unknown-linux-gnu"
            else if (stdenv.system == "x86_64-linux") then "x86_64-unknown-linux-gnu"
            else throw "System not supported";

  version = "2.9";
in

stdenv.mkDerivation {
  name = "clang-${version}";

  CC = if stdenv.gcc ? clang then "clang" else "gcc";

  CXX = if stdenv.gcc ? clang then "clang++" else "g++";

  src = llvm.src;

  buildInputs = [ perl llvm groff ];

  configureFlags = [ "--enable-optimized" "--enable-shared" "--disable-static" ];
  srcClang = fetchurl {
      url = "http://llvm.org/releases/${version}/clang-${version}.tgz";
      sha256 = "1pq9g7qxw761dp6gx3amx39kl9p4zhlymmn8gfmcnw9ag0zizi3h";
  };

  prePatch = ''
    pushd tools
    unpackFile $srcClang
    mv clang-${version} clang
    popd
    find
  '';

  patches = [ ./clang-include-paths.patch ./clang-ld-flags.patch ./clang-tblgen.patch ./clang-system-llvm-libs.patch ];

  buildFlags = [ "TableGen=tblgen" "LLVM_CONFIG=llvm-config" ];
  # Set up the header file paths
  preBuild = ''
    sed -i -e 's,C_INCLUDE_PATH,"${stdenv.gcc.libc}/include/",' \
      -e 's,CPP_HOST,"${triplet}",' \
      -e 's,CPP_INCLUDE_PATH,"${stdenv.gcc.gcc}/include/c++/${stdenv.gcc.gcc.version}",' \
      tools/clang/lib/Frontend/InitHeaderSearch.cpp

    pushd utils/unittest
    make
    popd
    cd tools/clang
  '';

  passthru = { gcc = stdenv.gcc.gcc; };

  meta = {
    homepage = http://clang.llvm.org/;
    description = "A C language family frontend for LLVM";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric shlevy];
    platforms = with stdenv.lib.platforms; linux;
  };
}
