{ stdenv, fetchurl, perl, groff, buildClang ? false }:

let version = "2.9"; in

stdenv.mkDerivation ({
  name = "llvm-${version}";

  CC = if stdenv.gcc ? clang then "clang" else "gcc";

  CXX = if stdenv.gcc ? clang then "clang++" else "g++";

  src = fetchurl {
    url    = "http://llvm.org/releases/${version}/llvm-${version}.tgz";
    sha256 = "0y9pgdakn3n0vf8zs6fjxjw6972nyw4rkfwwza6b8a3ll77kc4k6";
  };

  buildInputs = [ perl groff ];

  configureFlags = [ "--enable-optimized" "--enable-shared" "--disable-static" ];

  meta = {
    homepage = http://llvm.org/;
    description = "Collection of modular and reusable compiler and toolchain technologies";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric shlevy];
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
    name = "clang-${version}";

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

    patches = [ ./clang-include-paths.patch ./clang-ld-flags.patch ];

    # Set up the header file paths
    preConfigure = ''
      sed -i -e 's,C_INCLUDE_PATH,"${stdenv.gcc.libc}/include/",' \
        -e 's,CPP_HOST,"${triplet}",' \
        -e 's,CPP_INCLUDE_PATH,"${stdenv.gcc.gcc}/include/c++/${stdenv.gcc.gcc.version}",' \
        tools/clang/lib/Frontend/InitHeaderSearch.cpp
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
))
