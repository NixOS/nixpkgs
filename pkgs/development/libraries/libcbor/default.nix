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
  version = "unstable-2023-01-29"; # Musl fix hasn't been released yet.

  src = fetchFromGitHub {
    owner = "PJK";
    repo = "libcbor";
    rev = "cb4162f40d94751141b4d43b07c4add83e738a68";
    sha256 = "sha256-ZTa+wG1g9KsVoqJG/yqxo2fJ7OhPnaI9QcfOmpOT3pg=";
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
