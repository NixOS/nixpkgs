{ stdenv, fetchurl, gcc, flex, perl, libtool, groff
, buildClang ? false }:

stdenv.mkDerivation ({
  name = "llvm-2.8";
  
  src = fetchurl {
    url    = http://llvm.org/releases/2.8/llvm-2.8.tgz;
    sha256 = "0fyl2gk2ld28isz9bq4f6r4dhqm9vljfj3pdfwlc2v0w5xsdpb95";
  };

  buildInputs = [ gcc flex perl groff ];

  configureFlags = [ "--enable-optimized" "--enable-shared" "--disable-static" ];

  meta = {
    homepage = http://llvm.org/;
    description = "Collection of modular and reusable compiler and toolchain technologies";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
// stdenv.lib.optionalAttrs buildClang (
  # I write the assert because 'gcc.libc' will be evaluated although 'triplet' would not
  # evaluate properly (in the preConfigure below)
  assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";
  let
    triplet = if (stdenv.system == "i686-linux") then "i686-unknown-linux-gnu"
              else if (stdenv.system == "x86_64-linux") then "x86_64-unknown-linux-gnu"
              else throw "System not supported";
  in {
    name = "clang-2.8";

    srcClang = fetchurl {
      url = http://llvm.org/releases/2.8/clang-2.8.tgz;
      sha256 = "1hg0vqmyr4wdy686l2bga0rpin41v0q9ds2k5659m8z6acali0zd";
    };

    prePatch = ''
      pushd tools
      unpackFile $srcClang
      mv clang-2.8 clang
      popd
      find
    '';

    patches = [ ./clang-include-paths.patch ];

    # Set up the header file paths
    preConfigure = ''
      sed -i -e 's,C_INCLUDE_PATH,"${gcc.libc}/include/",' \
        -e 's,CPP_HOST,"${triplet}",' \
        -e 's,CPP_INCLUDE_PATH,"${gcc.gcc}/include/c++/${gcc.gcc.version}",' \
        tools/clang/lib/Frontend/InitHeaderSearch.cpp
    '';

    meta = {
      homepage = http://clang.llvm.org/;
      description = "A C language family frontend for LLVM";
      license = "BSD";
      maintainers = with stdenv.lib.maintainers; [viric];
      platforms = with stdenv.lib.platforms; linux;
    };
  }
))
