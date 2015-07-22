{ stdenv, fetchurl, noSysDirs
, langC ? true, langCC ? true, langFortran ? false, langTreelang ? false
, langJava ? false
, langVhdl ? false
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
, libcCross ? null
, crossStageStatic ? true
, gnat ? null
}:

assert langTreelang -> bison != null && flex != null;

assert cross != null -> profiledCompiler == false && enableMultilib == true;
assert (cross != null && crossStageStatic) -> (langCC == false && langFortran
== false && langTreelang == false);

assert langVhdl -> gnat != null;

with stdenv.lib;

let
  version = "4.3.6";

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
      " --with-headers=${libcCross}/include" +
      " --enable-__cxa_atexit" +
      " --enable-long-long" +
      " --enable-threads=posix" +
      " --enable-nls"
      );
  stageNameAddon = if crossStageStatic then "-stage-static" else
    "-stage-final";
  crossNameAddon = if cross != null then "-${cross.config}" + stageNameAddon else "";
in

stdenv.mkDerivation ({
  name = "${name}-${version}" + crossNameAddon;

  builder = ./builder.sh;

  src =
    optional /*langC*/ true (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-core-${version}.tar.bz2";
      sha256 = "0ygrfw3hgp48hkqipbl9lw38f27npigc2sm6f01g9iswpq1igbw6";
    }) ++
    optional langCC (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-g++-${version}.tar.bz2";
      sha256 = "105xz3991b57zx3146xwlpchdb2sjmlknclvi1iac2gawm4mhxhf";
    }) ++
    optional langFortran (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-fortran-${version}.tar.bz2";
      sha256 = "12bqvf53hvhrwjnh101vn9frb5g8cr98cra4f11dzhzs4ppydpi1";
    }) ++
    optional langJava (fetchurl {
      url = "mirror://gcc/releases/gcc-${version}/gcc-java-${version}.tar.bz2";
      sha256 = "03w6jln9gmdv149s774rlw4rzi2zhbqna54r86cd6mql8flmy7fs";
    });

  patches =
    [ ./pass-cxxcpp.patch ./libmudflap-cpp.patch ./siginfo_t_fix.patch ]
    ++ optional noSysDirs ./no-sys-dirs.patch
    ++ optional (noSysDirs && langFortran) ./no-sys-dirs-fortran.patch
    ++ optional langJava ./java-jvgenmain-link.patch
    ++ optional langVhdl ./ghdl-ortho-cflags.patch
    ++ optional langVhdl ./ghdl-runtime-o2.patch;
    
  inherit noSysDirs profiledCompiler staticCompiler crossStageStatic
    binutilsCross libcCross;
  targetConfig = if cross != null then cross.config else null;

  buildInputs = [texinfo gmp mpfr]
    ++ (optionals langTreelang [bison flex])
    ++ (optional (zlib != null) zlib)
    ++ (optional (boehmgc != null) boehmgc)
    ++ (optionals (cross != null) [binutilsCross])
    ++ (optionals langVhdl [gnat])
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
        ++ optional langVhdl     "vhdl"
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
  
  passthru = { inherit langC langCC langFortran langVhdl langTreelang
      enableMultilib; };

  # ghdl does not build fine with parallel building
  enableParallelBuilding = !langVhdl;

  meta = {
    homepage = "http://gcc.gnu.org/";
    license = "GPL/LGPL";
    description = "GNU Compiler Collection, 4.3.x";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

} // (if langJava then {
  postConfigure = ''
    make configure-gcc
    sed -i gcc/Makefile -e 's@^CFLAGS = .*@& -I${zlib}/include@ ; s@^LDFLAGS = .*@& -L${zlib}/lib@'
    sed -i gcc/Makefile -e 's@^CFLAGS = .*@& -I${boehmgc}/include@ ; s@^LDFLAGS = .*@& -L${boehmgc}/lib -lgc@'
  '';
} else {})
// (if langVhdl then rec {
  name = "ghdl-0.29";

  ghdlSrc = fetchurl {
    url = "http://ghdl.free.fr/ghdl-0.29.tar.bz2";
    sha256 = "15mlinr1lwljwll9ampzcfcrk9bk0qpdks1kxlvb70xf9zhh2jva";
  };

  # Ghdl has some timestamps checks, storing file timestamps in '.cf' files.
  # As we will change the timestamps to 1970-01-01 00:00:01, we also set the
  # content of that .cf to that value. This way ghdl does not complain on
  # the installed object files from the basic libraries (ieee, ...)
  postInstallGhdl = ''
    pushd $out
    find . -name "*.cf" -exec \
        sed 's/[0-9]*\.000" /19700101000001.000" /g' -i {} \;
    popd
  '';

  postUnpack = ''
    tar xvf ${ghdlSrc}
    mv ghdl-*/vhdl gcc*/gcc
    rm -Rf ghdl-*
  '';

  passthru.isGNU = true;

  meta = {
    homepage = "http://ghdl.free.fr/";
    license = stdenv.lib.licenses.gpl2Plus;
    description = "Complete VHDL simulator, using the GCC technology";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

} else {}))
