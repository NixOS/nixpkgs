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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "Linus789";
    repo = "wl-clip-persist";
    rev = "v${version}";
    hash = "sha256-dFhHsBazBHVWgPxoRDNwh8Yctt4w64E0RyFaHEC4mvk=";
  };

  cargoHash = "sha256-rhXVjXhRPCjt7ur7fQviGFXVtQneuFKWZcDNkhM9tkY=";

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
