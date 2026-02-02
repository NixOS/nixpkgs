{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  callPackage,
  installShellFiles,
  writableTmpDirAsHomeHook,
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

    version = "0.15.0";

    src = fetchFromGitHub {
      owner = "alexpasmantier";
      repo = "television";
      tag = finalAttrs.version;
      hash = "sha256-WjIvsLO+LIDNEx2fEn0oe6YwrQYMhmRqWTomIoSH3Co=";
    };

    cargoHash = "sha256-AI7B4z8C+q3xcaB+BpPb0IIyZeDpWxx2qZVWPJkG/sY=";

    strictDeps = true;
    nativeBuildInputs = [
      installShellFiles
      writableTmpDirAsHomeHook
    ];

    # TODO(@getchoo): Investigate selectively disabling some tests, or fixing them
    # https://github.com/NixOS/nixpkgs/pull/423662#issuecomment-3156362941
    doCheck = false;

    postInstall = ''
      installManPage target/${stdenv.hostPlatform.rust.cargoShortTarget}/assets/tv.1
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      mkdir -p $out/share/television
      for shell in bash zsh fish; do
        "$out/bin/tv" init $shell > completion.$shell

        # split shell completion and shell integration
        awk -v C=completion_pure.$shell -v D=$out/share/television/completion.$shell '
          NR==FNR { key=$0; nextfile }
          {
            if (!found && index($0, key)) found=1
            print > (found ? D : C)
          }
        ' television/utils/shell/completion.$shell completion.$shell

        installShellCompletion --cmd tv completion_pure.$shell
      done

      # nushell doesn't contain regular completion for now
      "$out/bin/tv" init nu > $out/share/television/completion.nu
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
