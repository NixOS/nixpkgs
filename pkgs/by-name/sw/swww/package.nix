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

rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "LGFae";
    repo = "swww";
    rev = "refs/tags/v${version}";
    hash = "sha256-ldy9HhIsWdtTdvtRLV3qDT80oX646BI4Q+YX5wJXbsc=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bitcode-0.6.0" = "sha256-D1Jv9k9m6m7dXjU8s4YMEMC39FOUN7Ix9SvLKhM1yh0=";
    };
  };

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
}
