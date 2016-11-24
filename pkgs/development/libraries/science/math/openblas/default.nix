{ stdenv, fetchurl, gfortran, perl, which, config, coreutils
# Most packages depending on openblas expect integer width to match pointer width,
# but some expect to use 32-bit integers always (for compatibility with reference BLAS).
, blas64 ? null
}:

with stdenv.lib;

let blas64_ = blas64; in

let local = config.openblas.preferLocalBuild or false;
    binary =
      { i686-linux = "32";
        armv7l-linux = "32";
        x86_64-linux = "64";
        x86_64-darwin = "64";
      }."${stdenv.system}" or (throw "unsupported system: ${stdenv.system}");
    genericFlags =
      [ "DYNAMIC_ARCH=${if stdenv.system == "armv7l-linux" then "0" else "1"}"
        "NUM_THREADS=64"
      ];
    localFlags = config.openblas.flags or
      optionals (hasAttr "target" config.openblas) [ "TARGET=${config.openblas.target}" ];
    blas64 = if blas64_ != null then blas64_ else hasPrefix "x86_64" stdenv.system;

    version = "0.2.19";
in
stdenv.mkDerivation {
  name = "openblas-${version}";
  src = fetchurl {
    url = "https://github.com/xianyi/OpenBLAS/archive/v${version}.tar.gz";
    sha256 = "0mw5ra1vjsqiba79zdhqfkqq6v3bla5a5c0wj7vca9qgjzjbah4w";
    name = "openblas-${version}.tar.gz";
  };

  inherit blas64;

  # Some hardening features are disabled due to sporadic failures in
  # OpenBLAS-based programs. The problem may not be with OpenBLAS itself, but
  # with how these flags interact with hardening measures used downstream.
  # In either case, OpenBLAS must only be used by trusted code--it is
  # inherently unsuitable for security-conscious applications--so there should
  # be no objection to disabling these hardening measures.
  hardeningDisable = [
    # don't modify or move the stack
    "stackprotector" "pic"
    # don't alter index arithmetic
    "strictoverflow"
    # don't interfere with dynamic target detection.
    "relro" "bindnow"
  ];

  nativeBuildInputs = optionals stdenv.isDarwin [coreutils] ++ [gfortran perl which];

  makeFlags =
    (if local then localFlags else genericFlags)
    ++
    optionals stdenv.isDarwin ["MACOSX_DEPLOYMENT_TARGET=10.7"]
    ++
    [
      "FC=gfortran"
      # Note that clang is available through the stdenv on OSX and
      # thus is not an explicit dependency.
      "CC=${if stdenv.isDarwin then "clang" else "gcc"}"
      ''PREFIX="''$(out)"''
      "BINARY=${binary}"
      "USE_OPENMP=${if stdenv.isDarwin then "0" else "1"}"
      "INTERFACE64=${if blas64 then "1" else "0"}"
    ]
    ++
    optionals (stdenv.system == "armv7l-linux") ["TARGET=ARMV7"];

  doCheck = true;
  checkTarget = "tests";

  meta = with stdenv.lib; {
    description = "Basic Linear Algebra Subprograms";
    license = licenses.bsd3;
    homepage = "https://github.com/xianyi/OpenBLAS";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ttuegel ];
  };
}
