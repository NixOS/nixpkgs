{
  lib,
  stdenv,
  version,
  hash,
  patches ? [ ],
  fetchFromGitHub,

  cmake,
  ninja,
  perl, # Project uses Perl for scripting and testing
  python3,

  enableThreading ? true, # Threading can be disabled to increase security https://tls.mbed.org/kb/development/thread-safety-and-multi-threading
}:

stdenv.mkDerivation rec {
  pname = "mbedtls";
  inherit version;

  src = fetchFromGitHub {
    owner = "Mbed-TLS";
    repo = "mbedtls";
    rev = "${pname}-${version}";
    inherit hash;
    # mbedtls >= 3.6.0 uses git submodules
    fetchSubmodules = true;
  };

  inherit patches;

  nativeBuildInputs = [
    cmake
    ninja
    perl
    python3
  ];

  strictDeps = true;

  # trivialautovarinit on clang causes test failures
  hardeningDisable = lib.optional stdenv.cc.isClang "trivialautovarinit";

  postConfigure = lib.optionalString enableThreading ''
    perl scripts/config.pl set MBEDTLS_THREADING_C    # Threading abstraction layer
    perl scripts/config.pl set MBEDTLS_THREADING_PTHREAD    # POSIX thread wrapper layer for the threading layer.
  '';

  cmakeFlags = [
    "-DUSE_SHARED_MBEDTLS_LIBRARY=${if stdenv.hostPlatform.isStatic then "off" else "on"}"

    # Avoid a dependency on jsonschema and jinja2 by not generating source code
    # using python. In releases, these generated files are already present in
    # the repository and do not need to be regenerated. See:
    # https://github.com/Mbed-TLS/mbedtls/releases/tag/v3.3.0 below "Requirement changes".
    "-DGEN_FILES=off"
  ]
  ++ lib.optionals stdenv.cc.isGNU [
    # mbedtls widely uses a pattern of starting unions with an
    # unsigned int dummy member, and then initializing those unions to
    # { 0 }.  The problem with this is that it only initializes that
    # first union member, so in the common case where the non-dummy
    # members are larger than the dummy member, they will only be
    # partially initialized since GCC 15[1].  Upstream has added
    # ad-hoc memset calls to mitigate this issue, but initializers are
    # also still widely used.  To avoid the risk of using
    # uninitialized memory, force the compiler to zero all bits of
    # unions, not just the first element, until upstream has a
    # systemic fix in place[2].
    #
    # [1]: https://gcc.gnu.org/gcc-15/changes.html
    # [2]: https://github.com/Mbed-TLS/mbedtls/issues/9885
    "-DCMAKE_C_FLAGS=-fzero-init-padding-bits=unions"
  ];

  doCheck = true;

  # Parallel checking causes test failures
  # https://github.com/Mbed-TLS/mbedtls/issues/4980
  enableParallelChecking = false;

  meta = {
    homepage = "https://www.trustedfirmware.org/projects/mbed-tls/";
    changelog = "https://github.com/Mbed-TLS/mbedtls/blob/${pname}-${version}/ChangeLog";
    description = "Portable cryptographic and TLS library, formerly known as PolarSSL";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.gpl2Plus
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ raphaelr ];
    knownVulnerabilities = lib.optionals (lib.versionOlder version "3.0") [
      "Mbed TLS 2 is not maintained anymore. Please migrate to newer versions"
    ];
  };
}
