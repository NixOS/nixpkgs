{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "tarmac";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "Roblox";
    repo = "tarmac";
    tag = "v${version}";
    hash = "sha256-WBkdC5YzZPtqQ9khxmvSFBHhZzfjICWkFcdi1PNsj5g=";
  };

  cargoHash = "sha256-u6EQLCdANSi1TBy2O1P5Ro5gJlfBjh/Xm7/uzCHtRu0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Resource compiler and asset manager for Roblox";
    mainProgram = "tarmac";
    longDescription = ''
      Tarmac is a resource compiler and asset manager for Roblox projects.
      It helps enable hermetic place builds when used with tools like Rojo.
    '';
    homepage = "https://github.com/Roblox/tarmac";
    downloadPage = "https://github.com/Roblox/tarmac/releases/tag/v${version}";
    changelog = "https://github.com/Roblox/tarmac/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
