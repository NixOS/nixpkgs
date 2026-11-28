{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  autoPatchelfHook,
  gcc-unwrapped,
  wayland,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wlgreet";
  version = "77261f8e8c40045b0eb83b679e2d5288bdc03ab4";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "wlgreet";
    rev = finalAttrs.version;
    hash = "sha256-hAn3zu1G8H5qgfkzSQUo/RcQPuwoEoAD6etHnlxhDrc=";
  };

  cargoHash = "sha256-YpSdlhyndPir2hnOEtmTiclc3fWMewjxbEH5Hzyhg7k=";

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ gcc-unwrapped ];

  runtimeDependencies = map lib.getLib [
    gcc-unwrapped
    wayland
    libxkbcommon
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Raw wayland greeter for greetd, to be run under sway or similar";
    mainProgram = "wlgreet";
    homepage = "https://git.sr.ht/~kennylevinsen/wlgreet";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
