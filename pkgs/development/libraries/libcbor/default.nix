{ lib
, stdenv
, fetchFromGitHub
, cmake
, cmocka

# for passthru.tests
, libfido2
, mysql80
, openssh
, systemd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcbor";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "PJK";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-YJSIZ7o191/0QJf1fH6LUYykS2pvP17knSeRO2WcDeM=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DBUILD_SHARED_LIBS=on"
  ] ++ lib.optional finalAttrs.doCheck "-DWITH_TESTS=ON";

  # 2 tests are not 32-bit clean: overflow size_t:
  #   https://github.com/PJK/libcbor/issues/263
  doCheck =
    !stdenv.hostPlatform.is32bit
    && (!stdenv.hostPlatform.isStatic)
    && stdenv.hostPlatform == stdenv.buildPlatform;
  nativeCheckInputs = [ cmocka ];

  passthru.tests = {
    inherit libfido2 mysql80;
    openssh = (openssh.override { withFIDO = true; });
    systemd = (systemd.override {
      withFido2 = true;
      withCryptsetup = true;
    });
  };

  meta = with lib; {
    description = "CBOR protocol implementation for C and others";
    homepage = "https://github.com/PJK/libcbor";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
})
