{
  lib,
  fetchFromGitHub,
  rustPlatform,
  at-spi2-atk,
  pkg-config,
  glib,
  gtk4,
  gtk4-layer-shell,
  installShellFiles,
  scdoc,
}:
rustPlatform.buildRustPackage rec {
  pname = "wleave";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "AMNatty";
    repo = "wleave";
    rev = version;
    hash = "sha256-xl0JOepQDvYdeTv0LFYzp8QdufKXkayJcHklLBjupeA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-csnArsVk/Ifhi3aO3bSG0mkSA81KACxR/xC1L8JJfmc=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    scdoc
  ];

  buildInputs = [
    at-spi2-atk
    gtk4
    gtk4-layer-shell
    glib
  ];

  postPatch = ''
    substituteInPlace style.css \
      --replace-fail "/usr/share/wleave" "$out/share/${pname}"

    substituteInPlace src/main.rs \
      --replace-fail "/etc/wleave" "$out/etc/${pname}"
  '';

  postInstall = ''
    install -Dm644 -t "$out/etc/wleave" {"style.css","layout"}
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

  meta = with lib; {
    description = "Wayland-native logout script written in GTK4";
    homepage = "https://github.com/AMNatty/wleave";
    license = licenses.mit;
    mainProgram = "wleave";
    maintainers = with maintainers; [ ludovicopiero ];
    platforms = platforms.linux;
  };
}
