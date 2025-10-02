{
  lib,
  fetchCrate,
  rustPlatform,
  cmake,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "wyvern";
  version = "1.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-OjL3wEoh4fT2nKqb7lMefP5B0vYyUaTRj09OXPEVfW4=";
  };

  cargoPatches = [ ./cargo-lock.patch ];

  cargoHash = "sha256-3zcXHl/CK5p/5BpGwafMYF/ztE6Erid9nS49vRFyPfE=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Simple CLI client for installing and maintaining linux GOG games";
    mainProgram = "wyvern";
    homepage = "https://git.sr.ht/~nicohman/wyvern";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };
}
