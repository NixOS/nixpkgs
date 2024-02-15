{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "PJK";
    repo = "libcbor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eE11hYPsOKqfoX8fx/oYfOAichhUe4mMpNQNVZ6vAUI=";
  };

  outputs = [ "out" "dev" ];

  patches = [
    # Pull fix pending upstream inclusion to support
    # `CMAKE_INSTALL_INCLUDEDIR`:
    #   https://github.com/PJK/libcbor/pull/297
    (fetchpatch {
      name = "includedir.patch";
      url = "https://github.com/PJK/libcbor/commit/d00a63e6d6858a2ed6be9b431b42799ed2c99ad8.patch";
      hash = "sha256-kBCSbAHOCGOs/4Yu6Vh0jcmzA/jYPkkPXPGPrptRfyk=";
    })
  ];

  strictDeps = true;
  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cmocka # cmake expects cmocka module
  ];

  cmakeFlags = lib.optional finalAttrs.finalPackage.doCheck "-DWITH_TESTS=ON"
    ++ lib.optional (!stdenv.hostPlatform.isStatic) "-DBUILD_SHARED_LIBS=ON";

  # Tests are restricted while pkgsStatic.cmocka is broken. Tracked at:
  # https://github.com/NixOS/nixpkgs/issues/213623
  doCheck = !stdenv.hostPlatform.isStatic
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
