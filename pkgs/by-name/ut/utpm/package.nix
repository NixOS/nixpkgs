{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "utpm";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Thumuss";
    repo = "utpm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aXIHeYPY11vE6ALHfccv8DLnTTCXVjlmaeeA5YRzdzc=";
    postFetch = ''sed -i 's/^version = "0.2.0"$/version = "${finalAttrs.version}"/' $out/Cargo.toml'';
  };

  cargoHash = "sha256-mztWRNCONfcokkKhU4FKArtiL3u7Oxk6UStKld6fZuE=";

  env.OPENSSL_NO_VENDOR = 1;

  buildInputs = [
    openssl
  ];
  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Package manager for typst";
    longDescription = ''
      UTPM is a package manager for local and remote packages. Create quickly
      new projects and templates from a singular tool, and then publish it directly
      to Typst!
    '';
    homepage = "https://github.com/Thumuss/utpm";
    license = lib.licenses.mit;
    mainProgram = "utpm";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
})
