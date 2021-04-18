{ fetchzip, fetchFromGitHub, lib, pkgs, stdenv
# Build tools
, cmake, perl, python3, which
# Dependencies
, arpack, curl, blas, gmp, gfortran, lapack, libnghttp2, libssh2, mpfr, pcre2, libgit2
# The manual thinks we need those for compiling from source, https://github.com/JuliaLang/julia/blob/master/doc/build/build.md
, gawk, m4, pkg-config, patch
# Testing
, openssl
# Darwin
#, CoreServices, ApplicationServices 
}:


# TODO Update the dependency assertion
# Ensure dependencies from Nixpkgs are equal or greater to vendored versions.
assert lib.versionAtLeast (lib.strings.getVersion gmp) "6.1.2";
assert lib.versionAtLeast arpack.version "3.3.0";
assert lib.versionAtLeast curl.version "7.56.0";
assert lib.versionAtLeast libssh2.version "1.8.2";
assert lib.versionAtLeast mpfr.version "4.0.2";
assert lib.versionAtLeast pcre2.version "10.30";
# Can not assert for BLAS and LAPACK due to multiple providers, Julia uses:
#   * OpenBLAS: e8a68ef261a33568b0f0cf53e0e2287e9f12e69e
#   * LAPACK: 3.5.0

# Ensure BLAS and Lapack integer size compatibility.
assert (blas.isILP64 == lapack.isILP64);

let

in stdenv.mkDerivation rec {
  pname = "julia";
  version = "1.6.0";
  src = fetchzip {
    url = "https://github.com/JuliaLang/${pname}/releases/download/v${version}/${pname}-${version}-full.tar.gz";
    sha256 = "14qhd0vp2y9c6126niz37vkz3n7skd6h565fai3khhd0li63vka6";
  };

  patches = [
    # Patch the Assertion Error
    ./precompile_succeeded.patch
  ];
  prePatch = ''
    # Disable Distributed tests as they fail in the sandbox.
    echo > stdlib/Distributed/test/runtests.jl
  '';

  strictDeps = true;
  nativeBuildInputs = [ cmake curl gawk gfortran m4 pkg-config patch perl python3 which ];
  buildInputs = [
    arpack
    blas
    curl
    gmp
    lapack
    libgit2
    libnghttp2
    libssh2
    mpfr
    pcre2
  ]; # ++ lib.optionals stdenv.isDarwin [ CoreServices ApplicationServices ];
  # Julia creates symlinks in `lib/julia` by searching `LD_LIBRARY_PATH`.
  LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
  # CMake is used to build the vendored dependencies, not Julia itself.
  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;
  preBuild = ''
    makeFlagsArray+=(TAGGED_RELEASE_BANNER="Nix build: https://nixos.org")
  '';
  makeFlags = let
    # CPU targets and architectures lifted from the official build bot:
    #   https://github.com/JuliaCI/julia-buildbot/blob/master/master/inventory.py
    arch = lib.head (lib.splitString "-" stdenv.system);
    march = {
      x86_64 = stdenv.hostPlatform.gcc.arch or "x86-64";
      # Julia supports Pentium 4 (SSE2) and above.
      i686 = "pentium4";
      aarch64 = "armv8-a";
    }.${arch} or (throw "unsupported architecture: ${arch}");
    cpuTarget = {
      x86_64 = "generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)";
      i686 = "pentium4;sandybridge,-xsaveopt,clone_all";
      aarch64 = "generic;cortex-a57;thunderx2t99;armv8.2-a,crypto,fullfp16,lse,rdm";
    }.${arch} or (throw "unsupported architecture: ${arch}");
  in [
    "prefix=$(out)"
    "ARCH=${arch}"
    "MARCH=${march}"
    "JULIA_CPU_TARGET=${cpuTarget}"
    "SHELL=${stdenv.shell}"

    # The Julia project vendors its dependencies and not-yet-upstreamed patches
    # are common, thus we opt to preserve some key vendored dependencies.
    "USE_SYSTEM_LLVM=0"
    "USE_SYSTEM_LIBUV=0"
    # Libraries created/maintained by the Julia project, allow vendoring.
    "USE_SYSTEM_LIBM=0"
    "USE_SYSTEM_OPENLIBM=0"
    "USE_SYSTEM_UTF8PROC=0"
    # Currently missing in Nixpkgs, allow vendoring for now.
    "USE_SYSTEM_DSFMT=0"
    "USE_SYSTEM_SUITESPARSE=0"
    # We need this for 1.6, apparently
    "USE_BINARYBUILDER=0"
    "USE_SYSTEM_LIBUNWIND=0"

    (lib.optionalString (!stdenv.isDarwin) "USE_SYSTEM_BLAS=1")
    "USE_SYSTEM_ARPACK=1"
    "USE_SYSTEM_BLAS=1"
    "USE_SYSTEM_CURL=1"
    "USE_SYSTEM_GMP=1"
    "USE_SYSTEM_LAPACK=1"
    "USE_SYSTEM_LIBGIT2=1"
    "USE_SYSTEM_LIBSSH2=1"
    # Not necessary, used by libgit2 which is provided by Nixpkgs.
    #"USE_SYSTEM_MBEDTLS=1"
    "USE_SYSTEM_MPFR=1"
    "USE_SYSTEM_PATCHELF=1"
    "USE_SYSTEM_PCRE=1"

    # # Julia fails to locate the header as pcre2 is a split package.
    "PCRE_INCL_PATH=${pcre2.dev}/include/pcre2.h"
    "USE_BLAS64=${if blas.isILP64 then "1" else "0"}"
  ];

  # Deactivate the tests for now
  doCheck = false;
  checkTarget = "";
  # Some tests require read/write access to $HOME.
  preCheck = ''
    export HOME="$TMPDIR"
  '';
  checkInputs = [ openssl ];

  postInstall = ''
    # Symlink shared libraries from LD_LIBRARY_PATH into lib/julia,
    # as using a wrapper with LD_LIBRARY_PATH causes segmentation
    # faults when program returns an error:
    #   $ julia -e 'throw(Error())'
    #  We also need this for julia to find libnghttp2 on startup
    find $(echo $LD_LIBRARY_PATH | sed 's|:| |g') -maxdepth 1 -name '*.${if stdenv.isDarwin then "dylib" else "so"}*' | while read lib; do
      if [[ ! -e $out/lib/julia/$(basename $lib) ]]; then
        ln -sv $lib $out/lib/julia/$(basename $lib)
      fi
    done
  ''; 

  meta = {
    description = "High-level, high-performance dynamic language for technical computing";
    homepage = "https://julialang.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ garrison raskin rob ninjin cstich];
    platforms = [ "aarch64-linux" "i686-linux" "x86_64-darwin" "x86_64-linux" ];
  };
}
