{ stdenv, fetchurl, perl, groff, llvm }:

assert stdenv.isLinux && stdenv.gcc.gcc != null;

let version = "2.9"; in

stdenv.mkDerivation {
  name = "clang-${version}";

  src = llvm.src;

  buildInputs = [ perl llvm groff ];

  configureFlags = [ "--enable-optimized" "--enable-shared" "--disable-static" ]
    ++ stdenv.lib.optionals (stdenv.gcc ? clang) [
      "--with-built-clang=yes"
      "CXX=clang++"
    ];

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

  preBuild = ''
    sed -i -e 's,C_INCLUDE_PATH,"${stdenv.gcc.libc}/include/",' \
      -e 's,CPP_HOST,"'$(${stdenv.gcc.gcc}/bin/gcc -dumpmachine)'",' \
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
