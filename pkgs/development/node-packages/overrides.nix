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

  "@electron-forge/cli" = prev."@electron-forge/cli".override {
    buildInputs = [ final.node-gyp-build ];
  };

  fast-cli = prev.fast-cli.override {
    nativeBuildInputs = [ pkgs.buildPackages.makeWrapper ];
    prePatch = ''
      export PUPPETEER_SKIP_DOWNLOAD=1
    '';
    postInstall = ''
      wrapProgram $out/bin/fast \
        --set PUPPETEER_EXECUTABLE_PATH ${pkgs.chromium.outPath}/bin/chromium
    '';
  };

  fauna-shell = prev.fauna-shell.override {
    # printReleaseNotes just pulls them from GitHub which is not allowed in sandbox
    preRebuild = ''
      sed -i 's|"node ./tools/printReleaseNotes"|"true"|' node_modules/faunadb/package.json
    '';
  };

  joplin = prev.joplin.override (oldAttrs: {
    nativeBuildInputs = [
      pkgs.pkg-config
      (pkgs.python3.withPackages (ps: [ ps.setuptools ]))
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      pkgs.xcbuild
    ];
    buildInputs = with pkgs; [
      # required by sharp
      # https://sharp.pixelplumbing.com/install
      vips

      libsecret
      final.node-gyp-build
      node-pre-gyp

      pixman
      cairo
      pango
    ];

    # add newer node-addon-api to build sharp
    # https://github.com/lovell/sharp/issues/3920
    dependencies = [
      {
        name = "node-addon-api";
        packageName = "node-addon-api";
        version = "7.1.0";
        src = fetchurl {
          url = "https://registry.npmjs.org/node-addon-api/-/node-addon-api-7.1.0.tgz";
          sha512 = "mNcltoe1R8o7STTegSOHdnJNN7s5EUvhoS7ShnTHDyOSd+8H+UdWODq6qSv67PjC8Zc5JRT8+oLAMCr0SIXw7g==";
        };
      }
    ]
    ++ oldAttrs.dependencies;

    meta = oldAttrs.meta // {
      # ModuleNotFoundError: No module named 'distutils'
      broken = stdenv.hostPlatform.isDarwin; # still broken on darwin
    };
  });

  jsonplaceholder = prev.jsonplaceholder.override {
    buildInputs = [ nodejs ];
    postInstall = ''
      exe=$out/bin/jsonplaceholder
      mkdir -p $out/bin
      cat >$exe <<EOF
      #!${pkgs.runtimeShell}
      exec -a jsonplaceholder ${nodejs}/bin/node $out/lib/node_modules/jsonplaceholder/index.js
      EOF
      chmod a+x $exe
    '';
  };

  keyoxide = prev.keyoxide.override {
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = with pkgs; [
      pixman
      cairo
      pango
    ];
  };

  makam = prev.makam.override {
    nativeBuildInputs = [ pkgs.buildPackages.makeWrapper ];
    postFixup = ''
      wrapProgram "$out/bin/makam" --prefix PATH : ${lib.makeBinPath [ nodejs ]}
      ${lib.optionalString stdenv.hostPlatform.isLinux "patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 \"$out/lib/node_modules/makam/makam-bin-linux64\""}
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

  ts-node = prev.ts-node.override {
    nativeBuildInputs = [ pkgs.buildPackages.makeWrapper ];
    postInstall = ''
      wrapProgram "$out/bin/ts-node" \
      --prefix NODE_PATH : ${pkgs.typescript}/lib/node_modules
    '';
  };

  tsun = prev.tsun.override {
    nativeBuildInputs = [ pkgs.buildPackages.makeWrapper ];
    postInstall = ''
      wrapProgram "$out/bin/tsun" \
      --prefix NODE_PATH : ${pkgs.typescript}/lib/node_modules
    '';
  };

  uppy-companion = prev."@uppy/companion".override {
    name = "uppy-companion";
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

  vega-lite = prev.vega-lite.override {
    postInstall = ''
      cd node_modules
      for dep in ${final.vega-cli}/lib/node_modules/vega-cli/node_modules/*; do
        if [[ ! -d ''${dep##*/} ]]; then
          ln -s "${final.vega-cli}/lib/node_modules/vega-cli/node_modules/''${dep##*/}"
        fi
      done
    '';
    passthru.tests = {
      simple-execution = callPackage ./package-tests/vega-lite.nix {
        inherit (final) vega-lite;
      };
    };
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
