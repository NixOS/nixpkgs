{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,

  # Deps
  installShellFiles,
  pkg-config,
  scdoc,
  wrapGAppsHook4,
  at-spi2-atk,
  glib,
  gtk4,
  gtk4-layer-shell,
  libadwaita,
  librsvg,
  libxml2,
}:
rustPlatform.buildRustPackage rec {
  pname = "wleave";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "AMNatty";
    repo = "wleave";
    rev = version;
    hash = "sha256-+0EKnaxRaHRxRvhASuvfpUijEZJFimR4zSzOyC3FOkQ=";
  };

  cargoHash = "sha256-MRVWiQNzETFbWeKwYeoXSUY9gncRCsYdPEZhpOKcTvA=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    scdoc
    wrapGAppsHook4
  ];

  buildInputs = [
    at-spi2-atk
    glib
    gtk4
    gtk4-layer-shell
    libadwaita
    librsvg
    libxml2
  ];

  postPatch = ''
    substituteInPlace src/config.rs \
      --replace-fail "/etc/wleave" "$out/etc/${pname}"

    substituteInPlace layout.json \
      --replace-fail "/usr/share/wleave" "$out/share/${pname}"
  '';

  postInstall = ''
    install -Dm644 -t "$out/etc/wleave" {"style.css","layout.json"}
    install -Dm644 -t "$out/share/wleave/icons" icons/*

    for f in man/*.scd; do
      local page="man/$(basename "$f" .scd)"
      scdoc < "$f" > "$page"
      installManPage "$page"
    done

    installShellCompletion --cmd wleave \
      --bash <(cat completions/wleave.bash) \
      --fish <(cat completions/wleave.fish) \
      --zsh <(cat completions/_wleave)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Wayland-native logout script written in GTK4";
    homepage = "https://github.com/AMNatty/wleave";
    license = licenses.mit;
    mainProgram = "wleave";
    maintainers = with maintainers; [ ludovicopiero ];
    platforms = platforms.linux;
  };
}
