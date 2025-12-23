{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "toktop";
  version = "0.1.4";
  src = pkgs.fetchFromGitHub {
    owner = "htin1";
    hash = "sha256-7XeBDvGZDiw4syOrO13Lg9JfdgAciY0s56RYQC/aX9I=";
    repo = "toktop";
    tag = "v${finalAttrs.version}";
  };
  nativeBuildInputs = with pkgs; [pkg-config];
  buildInputs = with pkgs; [openssl];

  OPENSSL_NO_VENDOR = 1;
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  cargoHash = "sha256-F4yVcDmw9HMGzpALjwqu8J0Z7brLT8sUxpp/5bP1oHs=";
}
