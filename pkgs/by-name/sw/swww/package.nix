{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, lz4
, libxkbcommon
, installShellFiles
, scdoc
}:

rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "LGFae";
    repo = "swww";
    rev = "refs/tags/v${version}";
    hash = "sha256-JtwNrdXZbmR7VZeRiXcLEEOq1z7bF8idjp2D1Zpf3Z4=";
  };

  cargoHash = "sha256-FC3HeqWAMOTm2Tmzg+Sn/j0ZXyd8nsYH64MlwQwr8W0=";

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

  meta = with lib; {
    description = "Efficient animated wallpaper daemon for wayland, controlled at runtime";
    homepage = "https://github.com/LGFae/swww";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mateodd25 donovanglover ];
    platforms = platforms.linux;
    mainProgram = "swww";
  };
}
