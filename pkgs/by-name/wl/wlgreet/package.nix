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
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "wlgreet";
    rev = finalAttrs.version;
    hash = "sha256-TQTHFBOTxtSuzrAG4cjZ9oirl80xc0rPdYeLJ0t39DQ=";
  };

  cargoHash = "sha256-ITo9qvcT5aOybWLV7kn9BZbux6uxx1RwRGWCGQYdZ2I=";

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
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
