{ lib
, stdenv
, version
, hash
, fetchFromGitHub

, cmake
, ninja
, perl # Project uses Perl for scripting and testing
, python3

, enableThreading ? true # Threading can be disabled to increase security https://tls.mbed.org/kb/development/thread-safety-and-multi-threading
}:

stdenv.mkDerivation rec {
  pname = "mbedtls";
  inherit version;

  src = fetchFromGitHub {
    owner = "Mbed-TLS";
    repo = "mbedtls";
    rev = "${pname}-${version}";
    inherit hash;
  };

  nativeBuildInputs = [ cmake ninja perl python3 ];

  strictDeps = true;

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
  ];

  doCheck = true;

  # Parallel checking causes test failures
  # https://github.com/Mbed-TLS/mbedtls/issues/4980
  enableParallelChecking = false;

  meta = with lib; {
    homepage = "https://www.trustedfirmware.org/projects/mbed-tls/";
    changelog = "https://github.com/Mbed-TLS/mbedtls/blob/${pname}-${version}/ChangeLog";
    description = "Portable cryptographic and TLS library, formerly known as PolarSSL";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ raphaelr ];
  };
}
