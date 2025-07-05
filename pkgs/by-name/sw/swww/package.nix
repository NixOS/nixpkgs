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
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "LGFae";
    repo = "swww";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GXqXZn29r7ktL01KBzlPZ+9b1fdnAPF8qhsQxhiqAsQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-jCjeHeHML8gHtvFcnHbiGL5fZ3LhABhXrcUTQriUDc0=";

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
