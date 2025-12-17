{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  callPackage,
  installShellFiles,
  nix-update-script,
  testers,
  targetPackages,
  extraPackages ? null,
}:

assert
  (extraPackages == null)
  || lib.warn "Overriding television with the 'extraPackages' attribute is deprecated. Please use `television.withPackages (p: [ p.fd ...])` instead.";

let
  television = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "television";

    version = "0.14.0";

    src = fetchFromGitHub {
      owner = "alexpasmantier";
      repo = "television";
      tag = finalAttrs.version;
      hash = "sha256-3xzgLG4iHd4SvBgMu3MgpOPD0saVDaC8gXy+Y/wJ4q4=";
    };

    cargoHash = "sha256-3Ttar63EffTmU4pnwgZb/Zl9zIN9T9hAcV/uFUjypeQ=";

    strictDeps = true;
    nativeBuildInputs = [
      installShellFiles
    ];

    # TODO(@getchoo): Investigate selectively disabling some tests, or fixing them
    # https://github.com/NixOS/nixpkgs/pull/423662#issuecomment-3156362941
    doCheck = false;

    postPatch = ''
      # Remove keybinding overrides from shell completion scripts
      # Users should configure their own keybindings

      # Bash: Remove bind commands
      sed -i '/^# Bind the functions to key combinations/,$d' \
        television/utils/shell/completion.bash

      # Fish: Remove bind commands for both modes
      sed -i '/^for mode in default insert/,$d' \
        television/utils/shell/completion.fish

      # Nushell: Remove keybinding configuration
      sed -i '/^# Bind custom keybindings/,$d' \
        television/utils/shell/completion.nu

      # Zsh: Remove zle and bindkey commands
      sed -i '/^zle -N tv-smart-autocomplete/,$d' \
        television/utils/shell/completion.zsh
    '';

    postInstall = ''
      installManPage target/${stdenv.hostPlatform.rust.cargoShortTarget}/assets/tv.1

      installShellCompletion --cmd tv \
        television/utils/shell/completion.bash \
        television/utils/shell/completion.fish \
        television/utils/shell/completion.nu \
        television/utils/shell/completion.zsh
    '';

    passthru = {
      updateScript = nix-update-script { };

      withPackages =
        f:
        callPackage ./wrapper.nix {
          television = finalAttrs.finalPackage;
          extraPackages = f targetPackages;
        };

      tests = {
        version = testers.testVersion {
          package = finalAttrs.finalPackage;
          command = "XDG_DATA_HOME=$TMPDIR tv --version";
        };
        wrapper = testers.testVersion {
          package = finalAttrs.finalPackage.withPackages (pkgs: [
            pkgs.fd
            pkgs.git
          ]);

          command = "XDG_DATA_HOME=$TMPDIR tv --version";
        };
      };
    };

    meta = {
      description = "Blazingly fast general purpose fuzzy finder TUI";
      longDescription = ''
        Television is a fast and versatile fuzzy finder TUI.
        It lets you quickly search through any kind of data source (files, git
        repositories, environment variables, docker images, you name it) using a
        fuzzy matching algorithm and is designed to be easily extensible.
      '';
      homepage = "https://github.com/alexpasmantier/television";
      changelog = "https://github.com/alexpasmantier/television/releases/tag/${finalAttrs.version}";
      license = lib.licenses.mit;
      mainProgram = "tv";
      maintainers = with lib.maintainers; [
        louis-thevenet
        getchoo
        RossSmyth
      ];
    };
  });
in

if extraPackages == null then television else television.withPackages (lib.const extraPackages)
