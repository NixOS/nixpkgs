{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cargo,
  rustPlatform,
  rustc,
}:

stdenv.mkDerivation rec {
  pname = "zenoh-c";
  version = "1.4.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-c";
    tag = version;
    hash = "sha256-Mn3diwJgMkYXP9Dn5AqquN1UJ+P+b4QadiXqzzYZK+o=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname version;
    hash = "sha256-Z9xKC7svGPSuQm4KCKOfGAFOdWgSjBK+/LFT3rAebTg=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  postInstall = ''
    substituteInPlace $out/lib/pkgconfig/zenohc.pc \
      --replace-fail "\''${prefix}/" ""
  '';

  meta = {
    description = "C API for zenoh";
    homepage = "https://github.com/eclipse-zenoh/zenoh-c";
    license = with lib.licenses; [
      asl20
      epl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
  };
}
