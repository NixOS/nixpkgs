{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  lz4,
  libxkbcommon,
  installShellFiles,
  scdoc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swww";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "LGFae";
    repo = "swww";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ldy9HhIsWdtTdvtRLV3qDT80oX646BI4Q+YX5wJXbsc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-K1ww0bOD747EDtqYkA0Dlu7cwbjYcPwSXPSqQDbTwZo=";

  buildInputs = [
    lz4
    libxkbcommon
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
