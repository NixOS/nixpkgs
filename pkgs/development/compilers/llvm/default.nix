{stdenv, fetchurl, fetchsvn, gcc, flex, perl, libtool, groff
, buildClang ? false}:

stdenv.mkDerivation ({
  name = "llvm-2.7";
  src = fetchurl {
    url    = http://llvm.org/releases/2.7/llvm-2.7.tgz;
    sha256 = "19dwvfyxr851fjfsaxbm56gdj9mlivr37bv6h41hd8q3hpf4nrlr";
  };

  buildInputs = [ gcc flex perl libtool groff ];

  configureFlags = [ "--enable-optimized" "--enable-shared" ];

  meta = {
    homepage = http://llvm.org/;
    description = "Collection of modular and reusable compiler and toolchain technologies";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
//
(if buildClang then 
  # I write the assert because 'gcc.libc' will be evaluated although 'triplet' would not
  # evaluate properly (in the preConfigure below)
  assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";
  let
    triplet = if (stdenv.system == "i686-linux") then "i686-unknown-linux-gnu"
              else if (stdenv.system == "x86_64-linux") then "x86_64-unknown-linux-gnu"
              else throw "System not supported";
  in {
    srcClang = fetchsvn {
      url = http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_27;
      rev = 105900;
      sha256 = "fe79988950319b62d3bca34848424f20a3f33c8182507df222f2ac93fbacf671";
    };

    prePatch = ''
      pushd tools
      cp -R "$srcClang" clang
      chmod u+w -R clang
      popd
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
      maintainers = with stdenv.lib.maintainers; [viric];
      platforms = with stdenv.lib.platforms; linux;
    };
  }
else {}
))
