{ stdenv
, fetch
, fetchpatch
, perl
, groff
, cmake
, python2
, libffi
, libbfd
, libxml2
, ncurses
, version
, zlib
, compiler-rt_src
, libcxxabi
, debugVersion ? false
, enableSharedLibraries ? !stdenv.isDarwin
}:

let
  src = fetch "llvm" "1masakdp9g2dan1yrazg7md5am2vacbkb3nahb3dchpc1knr8xxy";
in stdenv.mkDerivation rec {
  name = "llvm-${version}";

  unpackPhase = ''
    unpackFile ${src}
    mv llvm-${version}.src llvm
    sourceRoot=$PWD/llvm
    unpackFile ${compiler-rt_src}
    mv compiler-rt-* $sourceRoot/projects/compiler-rt
  '';

  buildInputs = [ perl groff cmake libxml2 python2 libffi ]
    ++ stdenv.lib.optional stdenv.isDarwin libcxxabi;

  propagatedBuildInputs = [ ncurses zlib ];

  # The goal here is to disable LLVM bindings (currently go and ocaml) regardless
  # of whether the impure CMake search sheananigans find the compilers in global
  # paths. This mostly exists because sandbox builds don't work very well on Darwin
  # and sometimes you get weird behavior if CMake finds go in your system path.
  # This would be far prettier if there were a CMake option to just disable bindings
  # but from what I can tell, there isn't such a thing. The file in question only
  # contains `if(WIN32)` conditions to check whether to disable bindings, so making
  # those always succeed has the net effect of disabling all bindings.
  prePatch = ''
    substituteInPlace cmake/config-ix.cmake --replace "if(WIN32)" "if(1)"
  ''
  + stdenv.lib.optionalString (stdenv ? glibc) ''
    (
      cd projects/compiler-rt
      patch -p1 < ${
        fetchpatch {
          name = "sigaltstack.patch"; # for glibc-2.26
          url = https://github.com/llvm-mirror/compiler-rt/commit/8a5e425a68d.diff;
          sha256 = "0h4y5vl74qaa7dl54b1fcyqalvlpd8zban2d1jxfkxpzyi7m8ifi";
        }
      }
    )
  '';

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  patches = stdenv.lib.optionals (!stdenv.isDarwin) [
    # llvm-config --libfiles returns (non-existing) static libs
    ../fix-llvm-config.patch
  ];

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
    "-DLLVM_INSTALL_UTILS=ON"  # Needed by rustc
    "-DLLVM_BUILD_TESTS=ON"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_ENABLE_RTTI=ON"
  ] ++ stdenv.lib.optional enableSharedLibraries
    "-DBUILD_SHARED_LIBS=ON"
    ++ stdenv.lib.optional (!isDarwin)
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
    ++ stdenv.lib.optionals ( isDarwin) [
    "-DLLVM_ENABLE_LIBCXX=ON"
    "-DCAN_TARGET_i386=false"
  ];

  NIX_LDFLAGS = "-lpthread"; # no idea what's the problem

  postBuild = ''
    rm -fR $out
  '';

  enableParallelBuilding = true;

  passthru.src = src;

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    maintainers = with stdenv.lib.maintainers; [ lovek323 raskin ];
    platforms   = stdenv.lib.platforms.all;
  };
}
