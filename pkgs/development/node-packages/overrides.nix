# Do not use overrides in this file to add  `meta.mainProgram` to packages. Use `./main-programs.nix`
# instead.
{ pkgs, nodejs }:

let
  inherit (pkgs)
    stdenv
    lib
    callPackage
    fetchFromGitHub
    fetchurl
    fetchpatch
    nixosTests
    ;

  since = version: lib.versionAtLeast nodejs.version version;
  before = version: lib.versionOlder nodejs.version version;
in

final: prev: {
  inherit nodejs;

  "@angular/cli" = prev."@angular/cli".override {
    prePatch = ''
      export NG_CLI_ANALYTICS=false
    '';
    nativeBuildInputs = [ pkgs.installShellFiles ];
    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      for shell in bash zsh; do
        installShellCompletion --cmd ng \
          --$shell <($out/bin/ng completion script)
      done
    '';
  };

  node2nix = prev.node2nix.override {
    # Get latest commit for misc fixes
    src = fetchFromGitHub {
      owner = "svanderburg";
      repo = "node2nix";
      rev = "315e1b85a6761152f57a41ccea5e2570981ec670";
      sha256 = "sha256-8OxTOkwBPcnjyhXhxQEDd8tiaQoHt91zUJX5Ka+IXco=";
    };
    nativeBuildInputs = [ pkgs.buildPackages.makeWrapper ];
    postInstall =
      let
        patches = [
          # Needed to fix packages with DOS line-endings after above patch - PR svanderburg/node2nix#314
          (fetchpatch {
            name = "convert-crlf-for-script-bin-files.patch";
            url = "https://github.com/svanderburg/node2nix/commit/91aa511fe7107938b0409a02ab8c457a6de2d8ca.patch";
            hash = "sha256-ISiKYkur/o8enKDzJ8mQndkkSC4yrTNlheqyH+LiXlU=";
          })
          # fix nodejs attr names
          (fetchpatch {
            url = "https://github.com/svanderburg/node2nix/commit/3b63e735458947ef39aca247923f8775633363e5.patch";
            hash = "sha256-pe8Xm4mjPh9oKXugoMY6pRl8YYgtdw0sRXN+TienalU=";
          })
          # Use top-level cctools in generated files - PR svanderburg/node2nix#334
          (fetchpatch {
            url = "https://github.com/svanderburg/node2nix/commit/31c308bba5f39ea0105f66b9f40dbe57fed7a292.patch";
            hash = "sha256-DdNRteonMvyffPh0uo0lUbsohKYnyqv0QcD9vjN6aXE=";
          })
          # Prefer util-linux over removed utillinux alias - PR svanderburg/node2nix#336
          (fetchpatch {
            url = "https://github.com/svanderburg/node2nix/commit/ef5dc43e15d13129a9ddf6164c7bc2800a25792e.patch";
            hash = "sha256-ByIA0oQmEfb4PyVwGEtrR3NzWiy1YCn1FPdSKNDkNCw=";
          })
        ];
      in
      ''
        ${lib.concatStringsSep "\n" (
          map (patch: "patch -d $out/lib/node_modules/node2nix -p1 < ${patch}") patches
        )}
        wrapProgram "$out/bin/node2nix" --prefix PATH : ${lib.makeBinPath [ pkgs.nix ]}
      '';
  };

  pulp = prev.pulp.override {
    # tries to install purescript
    npmFlags = toString [ "--ignore-scripts" ];

    nativeBuildInputs = [ pkgs.buildPackages.makeWrapper ];
    postInstall = ''
      wrapProgram "$out/bin/pulp" --suffix PATH : ${
        lib.makeBinPath [
          pkgs.purescript
        ]
      }
    '';
  };

  rush = prev."@microsoft/rush".override {
    name = "rush";
  };

  vega-cli = prev.vega-cli.override {
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = with pkgs; [
      node-pre-gyp
      pixman
      cairo
      pango
      libjpeg
    ];
  };

  wavedrom-cli = prev.wavedrom-cli.override {
    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.node-pre-gyp
    ];
    # These dependencies are required by
    # https://github.com/Automattic/node-canvas.
    buildInputs = with pkgs; [
      giflib
      pixman
      cairo
      pango
    ];
  };
}
