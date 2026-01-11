{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  lz4,
  libxkbcommon,
  installShellFiles,
  makeWrapper,
  procps,
  scdoc,
  wayland-protocols,
  wayland-scanner,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swww";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "LGFae";
    repo = "swww";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X2ptpXRo6ps5RxDe5RS7qfTaHWqBbBNw/aSdC2tzUG8=";
  };

  cargoHash = "sha256-5KZWsdo37NbFFkK8XFc0XI9iwBkpV8KsOaOc0y287Io=";

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
    makeWrapper
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

  postFixup = ''
    for program in $out/bin/*; do
      wrapProgram $program \
        --prefix PATH : "${lib.makeBinPath [ procps ]}"
    done
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
