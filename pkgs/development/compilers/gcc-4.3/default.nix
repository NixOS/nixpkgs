{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false, langTreelang ? false
, langJava ? false
, profiledCompiler ? false
, staticCompiler ? false
, enableShared ? true
, texinfo ? null
, gmp, mpfr
, bison ? null, flex ? null
, zlib ? null, boehmgc ? null
, enableMultilib ? false
, name ? "gcc"
, cross ? null
, binutilsCross ? null
, glibcCross ? null
, crossStageStatic ? true
}:

assert langTreelang -> bison != null && flex != null;

assert cross != null -> profiledCompiler == false && enableMultilib == true;
assert (cross != null && crossStageStatic) -> (langCC == false && langFortran
== false && langTreelang == false);

with stdenv.lib;

let
  version = "4.3.4";
  crossConfigureFlags =
    "--target=${cross.config}" +
    (if crossStageStatic then
      " --disable-libssp --disable-nls" +
      " --without-headers" +
      " --disable-threads " +
      " --disable-libmudflap " +
      " --disable-libgomp " +
      " --disable-shared"
      else
      " --with-headers=${glibcCross}/include" +
      " --enable-__cxa_atexit" +
      " --enable-long-long" +
      " --enable-threads=posix" +
      " --enable-nls"
      );
  stageNameAddon = if (crossStageStatic) then "-stage-static" else
    "-stage-final";
  crossNameAddon = if (cross != null) then "-${cross.config}" + stageNameAddon else "";

in

stdenv.mkDerivation ({
  name = "${name}-${version}" + crossNameAddon;
  
  builder = ./builder.sh;
  
  src =
    optional /*langC*/ true (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-core-${version}.tar.bz2";
      sha256 = "1yk80nwyw8vkpw8d3x7lkg3zrv3ngjqlvj0i8zslzgj7a27q729i";
    }) ++
    optional langCC (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-g++-${version}.tar.bz2";
      sha256 = "0d8pyk5c9zmph25f4fl63vd8vhljj6ildbxpz2hr594g5i6pplpq";
    }) ++
    optional langFortran (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-fortran-${version}.tar.bz2";
      sha256 = "1xf2njykv1qcgxiqwj693dxjf77ss1rcxirylvnsp5hs89mdlj12";
    }) ++
    optional langJava (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-java-${version}.tar.bz2";
      sha256 = "1v3krhxi3zyaqfj0x8dbxvg67fjp29cr1psyf71r9zf757p3vqsw";
    });
    
  patches =
    [./pass-cxxcpp.patch ./libmudflap-cpp.patch]
    ++ optional noSysDirs ./no-sys-dirs.patch
    ++ optional (noSysDirs && langFortran) ./no-sys-dirs-fortran.patch
    ++ optional langJava ./java-jvgenmain-link.patch;
    
  inherit noSysDirs profiledCompiler staticCompiler crossStageStatic
    binutilsCross glibcCross;
  targetConfig = if (cross != null) then cross.config else null;

  buildInputs = [texinfo gmp mpfr]
    ++ (optionals langTreelang [bison flex])
    ++ (optional (zlib != null) zlib)
    ++ (optional (boehmgc != null) boehmgc)
    ++ (optionals (cross != null) [binutilsCross])
    ;

  configureFlags = "
    ${if enableMultilib then "" else "--disable-multilib"}
    ${if enableShared then "" else "--disable-shared"}
    --disable-libstdcxx-pch
    --with-system-zlib
    --enable-languages=${
      concatStrings (intersperse ","
        (  optional langC        "c"
        ++ optional langCC       "c++"
        ++ optional langFortran  "fortran"
        ++ optional langJava     "java"
        ++ optional langTreelang "treelang"
        )
      )
    }
    ${if stdenv.isi686 then "--with-arch=i686" else ""}
    ${if cross != null then crossConfigureFlags else ""}
  ";
  #Above I added a hack on making the build different than the host.

  # Needed for the cross compilation to work
  AR = "ar";
  LD = "ld";
  CC = "gcc";

  NIX_EXTRA_LDFLAGS = if staticCompiler then "-static" else "";

  inherit gmp mpfr;
  
  passthru = { inherit langC langCC langFortran langTreelang enableMultilib; };

  meta = {
    homepage = "http://gcc.gnu.org/";
    license = "GPL/LGPL";
    description = "GNU Compiler Collection, 4.3.x";
  };
} // (if langJava then {
  postConfigure = ''
    make configure-gcc
    sed -i gcc/Makefile -e 's@^CFLAGS = .*@& -I${zlib}/include@ ; s@^LDFLAGS = .*@& -L${zlib}/lib@'
    sed -i gcc/Makefile -e 's@^CFLAGS = .*@& -I${boehmgc}/include@ ; s@^LDFLAGS = .*@& -L${boehmgc}/lib -lgc@'
  '';
} else {}))
