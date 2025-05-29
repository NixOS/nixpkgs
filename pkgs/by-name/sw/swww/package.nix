{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  lz4,
  libxkbcommon,
  installShellFiles,
  scdoc,
  wayland-protocols,
  wayland-scanner,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swww";
  version = "0.10.0-unstable-2025-05-27";

  # Fixes build for locating wayland.xml, go back to regular tagged releases at next version bump
  # https://codeberg.org/LGFae/waybackend/issues/2
  src = fetchFromGitHub {
    owner = "LGFae";
    repo = "swww";
    rev = "800619eb70c0f4293a5b449103f55a0a3cfe2963";
    hash = "sha256-zkw1r2mmICkplgXTyN6GckTy0XEBAEoz4H1VQuP8eMU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-L2mbQJ0dAiB8+NOATnrPhVrjHvE5zjA1frhPbLUJ3sI=";

  buildInputs = [
    lz4
    libxkbcommon
    wayland-protocols
    wayland-scanner
  ];

  doCheck = false; # Integration tests do not work in sandbox environment

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    scdoc
  ];

  postInstall = ''
    for f in doc/*.scd; do
      local page="doc/$(basename "$f" .scd)"
      scdoc < "$f" > "$page"
      installManPage "$page"
    done

    installShellCompletion --cmd swww \
      --bash completions/swww.bash \
      --fish completions/swww.fish \
      --zsh completions/_swww
  '';

  meta = {
    description = "Efficient animated wallpaper daemon for wayland, controlled at runtime";
    homepage = "https://github.com/LGFae/swww";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      mateodd25
      donovanglover
    ];
    platforms = lib.platforms.linux;
    mainProgram = "swww";
  };
})
