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
  version = "unstable-2023-01-29"; # Musl fix hasn't been released yet.

  src = fetchFromGitHub {
    owner = "PJK";
    repo = "libcbor";
    rev = "cb4162f40d94751141b4d43b07c4add83e738a68";
    sha256 = "sha256-ZTa+wG1g9KsVoqJG/yqxo2fJ7OhPnaI9QcfOmpOT3pg=";
  };

  strictDeps = true;
  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cmocka # cmake expects cmocka module
  ];

  cmakeFlags = lib.optional finalAttrs.doCheck "-DWITH_TESTS=ON"
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
