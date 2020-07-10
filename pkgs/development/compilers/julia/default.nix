{ stdenv
, fetchurl
# To fetch libuv fork
, fetchFromGitHub
, fetchpatch
# see https://github.com/JuliaLang/julia/blob/master/doc/build/build.md
# not native
, libunwind
, pcre2
, blas
, lapack
, mpfr
, suitesparse
, utf8proc
, mbedtls
, libssh2
, curl
, llvm_8
, libuv
, gmp
, libgit2
, patchelf
, zlib
, p7zip
, enableMKL ? false # not free
, libmFlavor ? "julia" # Julia's openlibm is the only libm we have packaged
# native
, m4
, gfortran
, perl
, python3
, which
, cmake
}:

let
  majorVersion = "1";
  minorVersion = "5";
  maintenanceVersion = "2";
  version = "${majorVersion}.${minorVersion}.${maintenanceVersion}";
  fetchJuliaPatch = {fname, sha256}: fetchpatch {
    url =
      "https://raw.githubusercontent.com/JuliaLang/julia/v${version}/deps/patches/${fname}";
    inherit sha256;
  };
  # TODO: Generate the patches lists used here with a script, based of
  # llvm-8.0* files found in
  # https://github.com/JuliaLang/julia/tree/master/deps/patches
  llvm' = llvm_8.overrideAttrs(oldAttrs: {
    patches =
      (if builtins.hasAttr "patches" oldAttrs then oldAttrs.patches else [])
      ++ (builtins.map fetchJuliaPatch [
        { fname = "llvm-8.0-D50167-scev-umin.patch";
          sha256 = "0qw6nx1d336dj65pdbi514fgn0p4g86qi09hrykznv0a4yx2ls8l"; }
        { fname = "llvm-8.0-D55758-tablegen-cond.patch";
          sha256 = "1kyfrqc67r4kggsb6gqqdyvc7wxfxsnygk09ycdxamngslnmph7l"; }
        { fname = "llvm-8.0-D59389-refactor-wmma.patch";
          sha256 = "1bwln15c2h28pg7d5kamk90v1iy2fg0iw7z8m40l50ayinyw3slc"; }
        { fname = "llvm-8.0-D59393-mma-ptx63-fix.patch";
          sha256 = "0nxsp0gks168pahw8l2mql2cvpxhksx5hfn4irzj1yv2kzfmkgxr"; }
        { fname = "llvm-8.0-D63688-wasm-isLocal.patch";
          sha256 = "1mjfm61ws8wfjb9lxa1fzhgnn07cmj35s35nlljmcd197b9q50kh"; }
        { fname = "llvm-8.0-D65174-limit-merge-stores.patch";
          sha256 = "1lbiqbb0g41kdimis05gf64cbwsz38wcm0qw3175cw7pkw90inq2"; }
        { fname = "llvm-8.0-D66401-mingw-reloc.patch";
          sha256 = "01dsw7jjy10bjlx4wqds5fgc622g1dgdpxfrhk5p0z9msrn21xz4"; }
        { fname = "llvm-8.0-D66657-codegen-degenerate.patch";
          sha256 = "1dqnda23s7lr97yrvknkq6dha6dqygip84rssa14cplfjj2l3cqd"; }
        { fname = "llvm-8.0-D71495-vectorize-freduce.patch";
          sha256 = "07dbz5pkyfkjrh7l0rc0kja5lsw91l29gyd3q19sh3mb04v7g5k8"; }
        { fname = "llvm-8.0-D75072-SCEV-add-type.patch";
          sha256 = "1xa5wgp4nbmyi9mxdj367gvykgaf6l2cd94ssnp16pqggqgz0c0c"; }
    ]);
    # The original expression does not run checks already, but just in case,
    # it's likely they will fail because Julia's devs can't be counted on, and
    # the price of encountering a failure and retrying is too high.
    doCheck = false;
  });
  libuv' = libuv.overrideAttrs(oldAttrs: rec {
    version = "julia-uv2-1.29.1";
    src = fetchFromGitHub {
      owner = "JuliaLang";
      repo = "libuv";
      # Taken from https://github.com/JuliaLang/julia/blob/v1.5.2/deps/libuv.version
      rev = version;
      sha256 = "040l7f1hk7xyza11sry5cj4fhw05na949865axqqhxnifdvnmfji";
    };
    # Tests fail with this branch
    doCheck = false;
  });
  # See https://discourse.julialang.org/t/no-documentation-for-the-state-of-patches-for-dependencies-of-julia/44735/8
  # and https://github.com/JuliaLang/julia/pull/31215
  gmp' = gmp.overrideAttrs(oldAttrs: rec {
    # Per https://github.com/JuliaLang/julia/blob/v1.5.2/deps/Versions.make#L18
    pname = "gmp-julia";
    version = "6.1.2";
    # Not rewritten if in overrideAttrs
    name = "${pname}-${version}";
    src = fetchurl { # we need to use bz2, others aren't in bootstrapping stdenv
      urls = [
        "mirror://gnu/gmp/gmp-${version}.tar.bz2"
        "ftp://ftp.gmplib.org/pub/gmp-${version}/gmp-${version}.tar.bz2"
      ];
      sha256 = "1clg7pbpk6qwxj5b2mw0pghzawp2qlm3jf9gdd8i6fl6yh2bnxaj";
    };
    patches =
      (if builtins.hasAttr "patches" oldAttrs then oldAttrs.patches else [])
      ++ (builtins.map fetchJuliaPatch [
        { fname = "gmp-config-ldflags.patch";
          sha256 = "09wp7ad9aav4fl7sfj9srprjxwdmqc42y52nm9cqq47axjkl2n21"; }
        { fname = "gmp-exception.patch";
          sha256 = "0vhmpxmp7iiw0hngkwwhzqkjgz9vrfvcn79l38mcralcb4ay136p"; }
        { fname = "gmp_alloc_overflow_func.patch";
          sha256 = "12gcbvr9r1n55r3cy2i6w0i1ap271wi1bp9lfds2l1pzg57ik41i"; }
    ]);
  });
  libunwind' = libunwind.overrideAttrs(oldAttrs: rec {
    pname = "libunwind-julia";
    version = "1.3.1";
    src = fetchurl {
      url = "mirror://savannah/libunwind/${oldAttrs.pname}-${version}.tar.gz";
      sha256 = "1y0l08k6ak1mqbfj6accf9s5686kljwgsl4vcqpxzk5n74wpm6a3";
    };
    patches =
      (if builtins.hasAttr "patches" oldAttrs then oldAttrs.patches else [])
      ++ (builtins.map fetchJuliaPatch [
        { fname = "libunwind-prefer-extbl.patch";
          sha256 = "0g1mra099bpvqh7sjsf1rsydsblrvg11fvn016a909n0679b78ff"; }
        { fname = "libunwind-static-arm.patch";
          sha256 = "1vax0w7yss6b0n0kccgn1q9c2p9aa129zwqaj5nci8zz13kwd17d"; }
    ]);
  });
in

stdenv.mkDerivation rec {
  pname = "julia";
  inherit version;

  src = fetchurl {
    url = "https://github.com/JuliaLang/julia/releases/download/v${version}/julia-${version}-full.tar.gz";
    sha256 = "sha256-hQrtP+OQV0iOxjPymvcF9a2ofjBY/WXkitJvkbcToZo=";
  };

  buildInputs = [
    pcre2
    blas
    lapack
    mpfr
    suitesparse
    utf8proc
    mbedtls
    libssh2
    curl
    libgit2
    patchelf
    zlib
    p7zip
    llvm'
    libuv'
    gmp'
    libunwind'
  ];

  makeFlags = [
    # Don't use the internet
    "USE_BINARYBUILDER=0"
    "PREFIX=$(out)"
    "prefix=$(out)"

    "USE_SYSTEM_LIBUNWIND=1"
    "USE_SYSTEM_PCRE=1"
    "PCRE_CONFIG=${pcre2.dev}/bin/pcre2-config"
    "PCRE_INCL_PATH=${pcre2.dev}/include/pcre2.h"
    # TODO: Package http://www.math.sci.hiroshima-u.ac.jp/~m-mat@math.sci.hiroshima-u.ac.jp/MT/SFMT/#dSFMT
    "USE_SYSTEM_DSFMT=0"
    "USE_SYSTEM_BLAS=1"
    "USE_SYSTEM_LAPACK=1"

    "USE_SYSTEM_GMP=1"
    # Deps that will probably never be used without being overrided first
    "USE_SYSTEM_LIBUV=1"
    "USE_SYSTEM_LLVM=1"

    "USE_SYSTEM_MPFR=1"
    "USE_SYSTEM_SUITESPARSE=1"
    "USE_SYSTEM_UTF8PROC=1"
    "USE_SYSTEM_MBEDTLS=1"
    "USE_SYSTEM_LIBSSH2=1"
    "USE_SYSTEM_CURL=1"
    "USE_SYSTEM_LIBGIT2=1"
    "USE_SYSTEM_PATCHELF=1"
    "USE_SYSTEM_ZLIB=1"
    "USE_SYSTEM_P7ZIP=1"
  ]
    ++ stdenv.lib.optionals enableMKL [ "USE_INTEL_MKL=1" ]
    # Choose a libm flavor to use. Currently only openlibm is supported - by julia.
    # TODO: Package intel's libm and this: https://hpc.llnl.gov/software/mathematical-software/libm
    ++ stdenv.lib.optionals (libmFlavor == "julia") [ "USE_SYSTEM_OPENLIBM=1" ]
    ++ stdenv.lib.optionals (libmFlavor == "intel") [ "USE_INTEL_LIBM=1" ]
    ++ stdenv.lib.optionals (libmFlavor == "llnl") [ "USE_SYSTEM_LIBM=1" ]
  ;

  nativeBuildInputs = [
    m4
    # needed by makefile, undeclared by upstream, see https://github.com/JuliaLang/julia/issues/36604
    which
    perl
    gfortran
    python3
    cmake
  ];
  # Cmake is needed to build some deps found in the tarball we fetch, and that
  # Julia is eventually going to be using. Because Julia itself uses plain make
  # files as a build system, we need to add cmake to $PATH and not make our own
  # stdenv use cmake as the build system.
  dontUseCmakeConfigure = true;

  # doCheck = true;

  passthru = {
    inherit majorVersion minorVersion maintenanceVersion;
    site = "share/julia/site/v${majorVersion}.${minorVersion}";
    llvm = llvm';
    libuv = libuv';
    gmp = gmp';
    libunwind = libunwind';
  };

  meta = {
    description = "High-level performance-oriented dynamical language for technical computing";
    homepage = "https://julialang.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ doronbehar raskin rob garrison ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    broken = stdenv.isi686;
  };
}
