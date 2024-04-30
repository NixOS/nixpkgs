{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "wl-clip-persist";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Linus789";
    repo = "wl-clip-persist";
    rev = "v${version}";
    hash = "sha256-gUi4Htui7IwldeK30C7SGTNc+0VHuzDZfJdaL8FmkGs=";
  };

  cargoHash = "sha256-Kt/XTcwclZENtw4vw2BntndqxvojEizCc2Oa0w+c1D0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ wayland ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Keep Wayland clipboard even after programs close";
    homepage = "https://github.com/Linus789/wl-clip-persist";
    inherit (wayland.meta) platforms;
    license = licenses.mit;
    mainProgram = "wl-clip-persist";
    maintainers = with maintainers; [ name-snrl ];
  };
}
