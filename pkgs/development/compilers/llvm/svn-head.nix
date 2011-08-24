{ stdenv, fetchurl, gcc, flex, perl, libtool, groff, fetchsvn
, buildClang ? false }:

let rev =  "134309"; in
stdenv.mkDerivation ({
  name = "llvm-r${rev}";
  
  src = fetchsvn {
    url    = "http://llvm.org/svn/llvm-project/llvm/trunk";
    inherit rev;
    sha256 = "136qwpcl22r5bl9y4kk94vgbha1m58xrggy7qw19lg7jkgxxj8s6";
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
  in rec {
    name = "clang-r${rev}";

    srcClang = fetchsvn {
      url = http://llvm.org/svn/llvm-project/cfe/trunk;
      inherit rev;
      sha256 = "0afbrjakfw6zgsplxblgzr2kwjndlnr2lnqjnbj16ggam5fcnhlr";
    };

    prePatch = ''
      cp -r ${srcClang} tools/clang
      chmod u+rwX -R tools/clang
    '';

    patches = [ ./clang-include-paths-svn.patch ];

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
