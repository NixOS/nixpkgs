{ stdenv, fetchgit, fetchurl
# build tools
, gfortran, git, m4, patchelf, perl, which
# libjulia dependencies
, libunwind, llvm, utf8proc, zlib
# standard library dependencies
, double_conversion, fftwSinglePrec, fftw, gmp, mpfr, pcre, pcre2
, openblas, arpack, suitesparse
, openspecfun, openlibm
, python2
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "julia";
  version = "0.4-20140903";
  name = "${pname}-${version}";

  src = fetchgit {
    url = "git://github.com/JuliaLang/julia.git";
    rev = "41128d9bf97623a61fab4dfee9df97f3d6aad18a";
    sha256 = "1f84c582bf8132ef7e4f2c78c0b27234794dd464b30508a1502b85ae88017322";
    #name = "julia-git-v${version}";
  };

  extraSrcs =
    let
      dsfmt_ver = "2.2.3";

      dsfmt_src = fetchurl {
        url = "http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-${dsfmt_ver}.tar.gz";
        name = "dsfmt-${dsfmt_ver}.tar.gz";
        md5 = "057c5a11d28296825fba584f561a4369";
      };

      rmath_ver = "0.1";

      rmath_src = fetchurl {
        url = "https://codeload.github.com/JuliaLang/Rmath-julia/legacy.tar.gz/v${rmath_ver}";
        name = "Rmath-julia-${rmath_ver}.tar.gz";
        md5 = "4e3f9e41e7b8cd3070225d1f5e8b21d9";
      };

      libuv_rev = "28f5f06b5ff6f010d666ec26552e0badaca5cdcd";

      libuv_src = fetchurl {
        url = "https://api.github.com/repos/JuliaLang/libuv/tarball/${libuv_rev}";
        name = "libuv-${libuv_rev}.tar.gz";
        md5 = "429c128e55147c8b43d6555fe406869b";
      };

      virtualenv_ver = "1.11.6";

      virtualenv_src = fetchurl {
        url = "https://pypi.python.org/packages/source/v/virtualenv/virtualenv-${virtualenv_ver}.tar.gz";
        name = "virtualenv-${virtualenv_ver}.tar.gz";
        md5 = "f61cdd983d2c4e6aeabb70b1060d6f49";
      };

    in [ dsfmt_src rmath_src libuv_src virtualenv_src ];

  prePatch = ''
    copy_kill_hash(){
      cp "$1" "$2/$(basename "$1" | sed -e 's/^[a-z0-9]*-//')"
    }

    for i in $extraSrcs; do
      copy_kill_hash "$i" deps
    done
  '';

  patches = [ ./fix-utf8proc-0.4.patch ];

  postPatch = ''
    patchShebangs .

    # ldconfig doesn't seem to ever work on NixOS; system-wide ldconfig cache
    # is probably not what we want anyway on non-NixOS
    sed -e "s@/sbin/ldconfig@true@" -i src/ccall.*
  '';

  buildInputs =
    [ libunwind llvm utf8proc zlib
      double_conversion fftw fftwSinglePrec gmp mpfr pcre pcre2
      openblas arpack suitesparse openspecfun openlibm
      git
    ];

  nativeBuildInputs = [ gfortran python2 git m4 patchelf perl which ];

  makeFlags =
    let
      arch = head (splitString "-" stdenv.system);
      march =
        { "x86_64-linux" = "x86-64";
          "x86_64-darwin" = "x86-64";
          "i686-linux" = "i686";
        }."${stdenv.system}" or (throw "unsupported system: ${stdenv.system}");
    in [
      "ARCH=${arch}"
      "MARCH=${march}"
      "JULIA_CPU_TARGET=${march}"
      "PREFIX=$(out)"
      "prefix=$(out)"
      "SHELL=${stdenv.shell}"

      "USE_SYSTEM_BLAS=1"
      "LIBBLAS=-lopenblas"
      "LIBBLASNAME=libopenblas"

      "USE_SYSTEM_LAPACK=1"
      "LIBLAPACK=-lopenblas"
      "LIBLAPACKNAME=libopenblas"

      "USE_SYSTEM_ARPACK=1"
      "USE_SYSTEM_FFTW=1"
      "USE_SYSTEM_GMP=1"
      "USE_SYSTEM_GRISU=1"
      "USE_SYSTEM_LIBUNWIND=1"
      "USE_SYSTEM_LLVM=1"
      "USE_SYSTEM_MPFR=1"
      "USE_SYSTEM_PATCHELF=1"
      "USE_SYSTEM_PCRE=1"
      "USE_SYSTEM_SUITESPARSE=1"
      "USE_SYSTEM_UTF8PROC=1"
      "USE_SYSTEM_ZLIB=1"
      "USE_SYSTEM_OPENLIBM=1"
      "USE_SYSTEM_OPENSPECFUN=1"
      "USE_SYSTEM_LIBGIT2=1"

      "UTF8PROC_INC=${utf8proc}/include"
      "SUITESPARSE_INC=-I${suitesparse}/include"
    ];

  NIX_CFLAGS_COMPILE = [ "-fPIC" ];

  # Julia tries to load these libraries dynamically at runtime, but they can't be found.
  # Easier by far to link against them as usual.
  # These go in LDFLAGS, where they affect only Julia itself, and not NIX_LDFLAGS,
  # where they would also be used for all the private libraries Julia builds.
  LDFLAGS = [
    "-larpack"
    "-lfftw3_threads"
    "-lfftw3f_threads"
    "-lgmp"
    "-lmpfr"
    "-lopenblas"
    "-lpcre2-8"
    "-lsuitesparse"
    "-lsuitesparseconfig"
    "-lopenlibm"
    "-lz"
  ];

  dontStrip = true;
  dontPatchELF = true;

  enableParallelBuilding = true;

  # Test fail on i686 (julia version 0.3.10)
  #doCheck = !stdenv.isi686;
  checkTarget = "testall";

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "http://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ raskin ttuegel ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
