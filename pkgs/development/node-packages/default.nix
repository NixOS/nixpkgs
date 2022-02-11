{ pkgs, nodejs, stdenv, applyPatches, fetchFromGitHub, fetchpatch, fetchurl, nixosTests }:

let
  inherit (pkgs) lib;
  since = version: pkgs.lib.versionAtLeast nodejs.version version;
  before = version: pkgs.lib.versionOlder nodejs.version version;
  super = import ./composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
  self = super // {
    "@angular/cli" = super."@angular/cli".override {
      prePatch = ''
        export NG_CLI_ANALYTICS=false
      '';
    };

    autoprefixer = super.autoprefixer.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/autoprefixer" \
          --prefix NODE_PATH : ${self.postcss}/lib/node_modules
      '';
      passthru.tests = {
        simple-execution = pkgs.callPackage ./package-tests/autoprefixer.nix { inherit (self) autoprefixer; };
      };
    };

    aws-azure-login = super.aws-azure-login.override {
      meta.platforms = pkgs.lib.platforms.linux;
      nativeBuildInputs = [ pkgs.makeWrapper ];
      prePatch = ''
        export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
      '';
      postInstall = ''
        wrapProgram $out/bin/aws-azure-login \
            --set PUPPETEER_EXECUTABLE_PATH ${pkgs.chromium}/bin/chromium
      '';
    };

    bower2nix = super.bower2nix.override {
      buildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        for prog in bower2nix fetch-bower; do
          wrapProgram "$out/bin/$prog" --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.git pkgs.nix ]}
        done
      '';
    };

    carbon-now-cli = super.carbon-now-cli.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      prePatch = ''
        export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
      '';
      postInstall = ''
        wrapProgram $out/bin/carbon-now \
          --set PUPPETEER_EXECUTABLE_PATH ${pkgs.chromium.outPath}/bin/chromium
      '';
    };

    deltachat-desktop = super."deltachat-desktop-../../applications/networking/instant-messengers/deltachat-desktop".override {
      meta.broken = true; # use the top-level package instead
    };

    fast-cli = super.fast-cli.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      prePatch = ''
        export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
      '';
      postInstall = ''
        wrapProgram $out/bin/fast \
          --set PUPPETEER_EXECUTABLE_PATH ${pkgs.chromium.outPath}/bin/chromium
      '';
    };

    hyperspace-cli = super."@hyperspace/cli".override {
      nativeBuildInputs = with pkgs; [
        makeWrapper
        libtool
        autoconf
        automake
      ];
      buildInputs = with pkgs; [
        nodePackages.node-gyp-build
        nodejs
      ];
      postInstall = ''
        wrapProgram "$out/bin/hyp" --prefix PATH : ${
          pkgs.lib.makeBinPath [ pkgs.nodejs ]
        }
      '';
      # See: https://github.com/NixOS/nixpkgs/issues/142196
      # [...]/@hyperspace/cli/node_modules/.bin/node-gyp-build: /usr/bin/env: bad interpreter: No such file or directory
      meta.broken = true;
    };

    mdctl-cli = super."@medable/mdctl-cli".override {
      nativeBuildInputs = with pkgs; with darwin.apple_sdk.frameworks; [
        glib
        libsecret
        pkg-config
      ] ++ lib.optionals stdenv.isDarwin [
        AppKit
        Security
      ];
      buildInputs = with pkgs; [
        nodePackages.node-gyp-build
        nodePackages.node-pre-gyp
        nodejs
      ];
    };

    coc-imselect = super.coc-imselect.override {
      meta.broken = since "10";
    };

    jshint = super.jshint.override {
      buildInputs = [ pkgs.phantomjs2 ];
    };

    dat = super.dat.override {
      buildInputs = [ self.node-gyp-build pkgs.libtool pkgs.autoconf pkgs.automake ];
      meta.broken = since "12";
    };

    # NOTE: this is a stub package to fetch npm dependencies for
    # ../../applications/video/epgstation
    epgstation = super."epgstation-../../applications/video/epgstation".override (drv: {
      meta = drv.meta // {
        broken = true; # not really broken, see the comment above
      };
    });

    bitwarden-cli = super."@bitwarden/cli".override (drv: {
      name = "bitwarden-cli-${drv.version}";
      meta.mainProgram = "bw";
    });

    flood = super.flood.override {
      buildInputs = [ self.node-pre-gyp ];
      meta.mainProgram = "flood";
    };

    expo-cli = super."expo-cli".override (attrs: {
      # The traveling-fastlane-darwin optional dependency aborts build on Linux.
      dependencies = builtins.filter (d: d.packageName != "@expo/traveling-fastlane-${if stdenv.isLinux then "darwin" else "linux"}") attrs.dependencies;
    });

    "@electron-forge/cli" = super."@electron-forge/cli".override {
      buildInputs = [ self.node-pre-gyp self.rimraf ];
    };

    git-ssb = super.git-ssb.override {
      buildInputs = [ self.node-gyp-build ];
      meta.broken = since "10";
    };

    hsd = super.hsd.override {
      buildInputs = [ self.node-gyp-build pkgs.unbound ];
    };

    ijavascript = super.ijavascript.override (oldAttrs: {
      preRebuild = ''
        export NPM_CONFIG_ZMQ_EXTERNAL=true
      '';
      buildInputs = oldAttrs.buildInputs ++ [ self.node-gyp-build pkgs.zeromq ];
    });

    insect = super.insect.override (drv: {
      nativeBuildInputs = drv.nativeBuildInputs or [] ++ [ pkgs.psc-package self.pulp ];
    });

    intelephense = super.intelephense.override {
      meta.license = pkgs.lib.licenses.unfree;
    };

    jsonplaceholder = super.jsonplaceholder.override (drv: {
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
    });

    makam =  super.makam.override {
      buildInputs = [ pkgs.nodejs pkgs.makeWrapper ];
      postFixup = ''
        wrapProgram "$out/bin/makam" --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs ]}
        ${
          if stdenv.isLinux
            then "patchelf --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 \"$out/lib/node_modules/makam/makam-bin-linux64\""
            else ""
        }
      '';
    };

    manta = super.manta.override {
      nativeBuildInputs = with pkgs; [ nodejs-12_x installShellFiles ];
      postInstall = ''
        # create completions, following upstream procedure https://github.com/joyent/node-manta/blob/v5.2.3/Makefile#L85-L91
        completion_cmds=$(find ./bin -type f -printf "%f\n")

        node ./lib/create_client.js
        for cmd in $completion_cmds; do
          installShellCompletion --cmd $cmd --bash <(./bin/$cmd --completion)
        done
      '';
    };

    markdownlint-cli = super.markdownlint-cli.override {
      meta.mainProgram = "markdownlint";
    };

    node-gyp = super.node-gyp.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      # Teach node-gyp to use nodejs headers locally rather that download them form https://nodejs.org.
      # This is important when build nodejs packages in sandbox.
      postInstall = ''
        wrapProgram "$out/bin/node-gyp" \
          --set npm_config_nodedir ${nodejs}
      '';
    };

    node-inspector = super.node-inspector.override {
      buildInputs = [ self.node-pre-gyp ];
      meta.broken = since "10";
    };

    node2nix = super.node2nix.override {
      buildInputs = [ pkgs.makeWrapper ];
      # We need to apply a patch to the source, but buildNodePackage doesn't allow patches.
      # So we pin the patched commit instead. The commit actually contains two other newer commits
      # since the last (1.9.0) release, but actually this is a good thing since one of them is a
      # Hydra-specific fix.
      src = applyPatches {
        src = fetchFromGitHub {
          owner = "svanderburg";
          repo = "node2nix";
          rev = "node2nix-1.9.0";
          sha256 = "0l4wp1131nhl9c14cn8bwawb8f77h1nfbnswgi5lp5m3kzkb27jn";
        };

        patches = [
          # remove node_ name prefix
          (fetchpatch {
            url = "https://github.com/svanderburg/node2nix/commit/b54d45207427ff46e90f16f2f32771fdc8bff5a4.patch";
            sha256 = "sha256-ubUdF0q3l4xxqZ7f9EiQEUQzyqxi9Q6zsRPETHlfzh8=";
          })
          # set meta platform
          (fetchpatch {
            url = "https://github.com/svanderburg/node2nix/commit/58736093161f2d237c17e75a96529b018cd0ac64.patch";
            sha256 = "0sif7803c9g6gjmmdniw5qxrq5igiz9nqdmdrcf1hxfi5x43a32h";
          })
          # Extract common logic from composePackage to a shell function
          (fetchpatch {
            url = "https://github.com/svanderburg/node2nix/commit/e4c951971df6c9f9584c7252971c13b55c369916.patch";
            sha256 = "0w8fcyr12g2340rn06isv40jkmz2khmak81c95zpkjgipzx7hp7w";
          })
        ];
      };
      postInstall = ''
        wrapProgram "$out/bin/node2nix" --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nix ]}
      '';
    };

    node-red = super.node-red.override {
      buildInputs = [ self.node-pre-gyp ];
    };

    mermaid-cli = super."@mermaid-js/mermaid-cli".override (
    if stdenv.isDarwin
    then {}
    else {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      prePatch = ''
        export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
      '';
      postInstall = ''
        wrapProgram $out/bin/mmdc \
        --set PUPPETEER_EXECUTABLE_PATH ${pkgs.chromium.outPath}/bin/chromium
      '';
    });

    pnpm = super.pnpm.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];

      preRebuild = ''
        sed 's/"link:/"file:/g' --in-place package.json
      '';

      postInstall = let
        pnpmLibPath = pkgs.lib.makeBinPath [
          nodejs.passthru.python
          nodejs
        ];
      in ''
        for prog in $out/bin/*; do
          wrapProgram "$prog" --prefix PATH : ${pnpmLibPath}
        done
      '';
    };

    postcss-cli = super.postcss-cli.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/postcss" \
          --prefix NODE_PATH : ${self.postcss}/lib/node_modules \
          --prefix NODE_PATH : ${self.autoprefixer}/lib/node_modules
      '';
      passthru.tests = {
        simple-execution = pkgs.callPackage ./package-tests/postcss-cli.nix {
          inherit (self) postcss-cli;
        };
      };
      meta.mainProgram = "postcss";
    };

    prisma = super.prisma.override rec {
      nativeBuildInputs = [ pkgs.makeWrapper ];

      inherit (pkgs.prisma-engines) version;

      src = fetchurl {
        url = "https://registry.npmjs.org/prisma/-/prisma-${version}.tgz";
        sha512 = "sha512-xLmVyO/L6C4ZdHzHqiJVq3ZfDWSym29x75JcwJx746ps61UcNEg4ozSwN9ud7UjXLntdXe1xDLNOUO1lc7LN5g==";
      };
      postInstall = with pkgs; ''
        wrapProgram "$out/bin/prisma" \
          --set PRISMA_MIGRATION_ENGINE_BINARY ${prisma-engines}/bin/migration-engine \
          --set PRISMA_QUERY_ENGINE_BINARY ${prisma-engines}/bin/query-engine \
          --set PRISMA_QUERY_ENGINE_LIBRARY ${lib.getLib prisma-engines}/lib/libquery_engine.node \
          --set PRISMA_INTROSPECTION_ENGINE_BINARY ${prisma-engines}/bin/introspection-engine \
          --set PRISMA_FMT_BINARY ${prisma-engines}/bin/prisma-fmt
      '';
    };

    pulp = super.pulp.override {
      # tries to install purescript
      npmFlags = "--ignore-scripts";

      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall =  ''
        wrapProgram "$out/bin/pulp" --suffix PATH : ${pkgs.lib.makeBinPath [
          pkgs.purescript
        ]}
      '';
    };

    reveal-md = super.reveal-md.override (
      lib.optionalAttrs (!stdenv.isDarwin) {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        prePatch = ''
          export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
        '';
        postInstall = ''
          wrapProgram $out/bin/reveal-md \
          --set PUPPETEER_EXECUTABLE_PATH ${pkgs.chromium.outPath}/bin/chromium
        '';
      }
    );

    ssb-server = super.ssb-server.override {
      buildInputs = [ pkgs.automake pkgs.autoconf self.node-gyp-build ];
      meta.broken = since "10";
    };

    stf = super.stf.override {
      meta.broken = since "10";
    };

    tailwindcss = super.tailwindcss.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/tailwind" \
          --prefix NODE_PATH : ${self.postcss}/lib/node_modules
        wrapProgram "$out/bin/tailwindcss" \
          --prefix NODE_PATH : ${self.postcss}/lib/node_modules
      '';
      passthru.tests = {
        simple-execution = pkgs.callPackage ./package-tests/tailwindcss.nix { inherit (self) tailwindcss; };
      };
    };

    tedicross = super."tedicross-git+https://github.com/TediCross/TediCross.git#v0.8.7".override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        makeWrapper '${nodejs}/bin/node' "$out/bin/tedicross" \
          --add-flags "$out/lib/node_modules/tedicross/main.js"
      '';
    };

    tsun = super.tsun.overrideAttrs (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/tsun" \
        --prefix NODE_PATH : ${self.typescript}/lib/node_modules
      '';
    });

    typescript-language-server = super.typescript-language-server.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/typescript-language-server" \
          --suffix PATH : ${pkgs.lib.makeBinPath [ self.typescript ]}
      '';
    };

    teck-programmer = super.teck-programmer.override {
      nativeBuildInputs = [ self.node-gyp-build ];
      buildInputs = [ pkgs.libusb1 ];
    };

    uppy-companion = super."@uppy/companion".override {
      name = "uppy-companion";
    };

    vega-cli = super.vega-cli.override {
      nativeBuildInputs = [ pkgs.pkg-config ];
      buildInputs = with pkgs; [
        super.node-pre-gyp
        pixman
        cairo
        pango
        libjpeg
      ];
    };

    vega-lite = super.vega-lite.override {
        postInstall = ''
          cd node_modules
          for dep in ${self.vega-cli}/lib/node_modules/vega-cli/node_modules/*; do
            if [[ ! -d $dep ]]; then
              ln -s "${self.vega-cli}/lib/node_modules/vega-cli/node_modules/$dep"
            fi
          done
        '';
        passthru.tests = {
          simple-execution = pkgs.callPackage ./package-tests/vega-lite.nix {
            inherit (self) vega-lite;
          };
        };
    };

    webtorrent-cli = super.webtorrent-cli.override {
      buildInputs = [ self.node-gyp-build ];
    };

    joplin = super.joplin.override {
      nativeBuildInputs = [ pkgs.pkg-config ];
      buildInputs = with pkgs; [
        # required by sharp
        # https://sharp.pixelplumbing.com/install
        vips

        libsecret
        self.node-gyp-build
        self.node-pre-gyp
      ] ++ lib.optionals stdenv.isDarwin [
        darwin.apple_sdk.frameworks.AppKit
        darwin.apple_sdk.frameworks.Security
      ];
    };

    thelounge = super.thelounge.override {
      buildInputs = [ self.node-pre-gyp ];
      postInstall = ''
        echo /var/lib/thelounge > $out/lib/node_modules/thelounge/.thelounge_home
        patch -d $out/lib/node_modules/thelounge -p1 < ${./thelounge-packages-path.patch}
      '';
      passthru.tests = { inherit (nixosTests) thelounge; };
      meta = super.thelounge.meta // { maintainers = with lib.maintainers; [ winter ]; };
    };

    triton = super.triton.override {
      nativeBuildInputs = [ pkgs.installShellFiles ];
      postInstall = ''
        installShellCompletion --cmd triton --bash <($out/bin/triton completion)
      '';
    };

    yaml-language-server = super.yaml-language-server.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/yaml-language-server" \
        --prefix NODE_PATH : ${self.prettier}/lib/node_modules
      '';
    };

    wavedrom-cli = super.wavedrom-cli.override {
      nativeBuildInputs = [ pkgs.pkg-config self.node-pre-gyp ];
      # These dependencies are required by
      # https://github.com/Automattic/node-canvas.
      buildInputs = with pkgs; [
        pixman
        cairo
        pango
      ];
    };
  };
in self
