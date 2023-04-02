{ lib, stdenv
, fetchFromGitHub

, cmake
, ninja
, perl # Project uses Perl for scripting and testing
, python3

, enableThreading ? true # Threading can be disabled to increase security https://tls.mbed.org/kb/development/thread-safety-and-multi-threading
}:

stdenv.mkDerivation rec {
  pname = "mbedtls";
  # Auto updates are disabled due to repology listing dev releases as release
  # versions. See
  #  * https://github.com/NixOS/nixpkgs/pull/119838#issuecomment-822100428
  #  * https://github.com/NixOS/nixpkgs/commit/0ee02a9d42b5fe1825b0f7cee7a9986bb4ba975d
  version = "2.28.3"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "ARMmbed";
    repo = "mbedtls";
    rev = "${pname}-${version}";
    sha256 = "sha256-w5bJErCNRZLE8rHcuZlK3bOqel97gPPMKH2cPGUR6Zw=";
  };

  nativeBuildInputs = [ cmake ninja perl python3 ];

  strictDeps = true;

  postConfigure = lib.optionalString enableThreading ''
    perl scripts/config.pl set MBEDTLS_THREADING_C    # Threading abstraction layer
    perl scripts/config.pl set MBEDTLS_THREADING_PTHREAD    # POSIX thread wrapper layer for the threading layer.
  '';

  cmakeFlags = [ "-DUSE_SHARED_MBEDTLS_LIBRARY=on" ];
  NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [
    "-Wno-error=format"
    "-Wno-error=format-truncation"
  ];

  meta = with lib; {
    homepage = "https://tls.mbed.org/";
    description = "Portable cryptographic and TLS library, formerly known as PolarSSL";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
  };
}
