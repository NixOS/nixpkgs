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

    version = "0.14.1";

    src = fetchFromGitHub {
      owner = "alexpasmantier";
      repo = "television";
      tag = finalAttrs.version;
      hash = "sha256-PBWadCAGfCgYcNZpkQhY9g7mrKQgkJ9UhqMjAcM/IuU=";
    };

    cargoHash = "sha256-aa+XV1QUHjL2AjO+0AkMYimJeB7bNdb7ShrgNwevJc8=";

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

      # These are actually shell integrations with keybindings
      install -Dm644 television/utils/shell/completion.* -t $out/share/television/
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd tv \
        --bash <($out/bin/tv init bash) \
        --fish <($out/bin/tv init fish) \
        --zsh <($out/bin/tv init zsh) \
        --nushell <($out/bin/tv init nu)
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
