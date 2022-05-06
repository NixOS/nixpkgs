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

    "@electron-forge/cli" = super."@electron-forge/cli".override {
      buildInputs = [ self.node-pre-gyp self.rimraf ];
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

    aws-azure-login = super.aws-azure-login.override (oldAttrs: {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      prePatch = ''
        export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
      '';
      postInstall = ''
        wrapProgram $out/bin/aws-azure-login \
            --set PUPPETEER_EXECUTABLE_PATH ${pkgs.chromium}/bin/chromium
      '';
      meta = oldAttrs.meta // { platforms = pkgs.lib.platforms.linux; };
    });

    bitwarden-cli = super."@bitwarden/cli".override (oldAttrs: {
      name = "bitwarden-cli";
      meta = oldAttrs.meta // { mainProgram = "bw"; };
    });

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

    coc-imselect = super.coc-imselect.override (oldAttrs: {
      meta = oldAttrs.meta // { broken = since "10"; };
    });

    dat = super.dat.override (oldAttrs: {
      buildInputs = [ self.node-gyp-build pkgs.libtool pkgs.autoconf pkgs.automake ];
      meta = oldAttrs.meta // { broken = since "12"; };
    });

    deltachat-desktop = super."deltachat-desktop-../../applications/networking/instant-messengers/deltachat-desktop".override (oldAttrs: {
      meta = oldAttrs.meta // { broken = true; }; # use the top-level package instead
    });

    # NOTE: this is a stub package to fetch npm dependencies for
    # ../../applications/video/epgstation
    epgstation = super."epgstation-../../applications/video/epgstation".override (oldAttrs: {
      buildInputs = [ self.node-pre-gyp self.node-gyp-build ];
      meta = oldAttrs.meta // { platforms = pkgs.lib.platforms.none; };
    });

    # NOTE: this is a stub package to fetch npm dependencies for
    # ../../applications/video/epgstation/client
    epgstation-client = super."epgstation-client-../../applications/video/epgstation/client".override (oldAttrs: {
      meta = oldAttrs.meta // { platforms = pkgs.lib.platforms.none; };
    });

    expo-cli = super."expo-cli".override (oldAttrs: {
      # The traveling-fastlane-darwin optional dependency aborts build on Linux.
      dependencies = builtins.filter (d: d.packageName != "@expo/traveling-fastlane-${if stdenv.isLinux then "darwin" else "linux"}") oldAttrs.dependencies;
    });

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

    flood = super.flood.override (oldAttrs: {
      buildInputs = [ self.node-pre-gyp ];
      meta = oldAttrs.meta // { mainProgram = "flood"; };
    });

    git-ssb = super.git-ssb.override (oldAttrs: {
      buildInputs = [ self.node-gyp-build ];
      meta = oldAttrs.meta // { broken = since "10"; };
    });

    hsd = super.hsd.override {
      buildInputs = [ self.node-gyp-build pkgs.unbound ];
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
    };

    ijavascript = super.ijavascript.override (oldAttrs: {
      preRebuild = ''
        export NPM_CONFIG_ZMQ_EXTERNAL=true
      '';
      buildInputs = oldAttrs.buildInputs ++ [ self.node-gyp-build pkgs.zeromq ];
    });

    insect = super.insect.override (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [ pkgs.psc-package self.pulp ];
    });

    intelephense = super.intelephense.override (oldAttrs: {
      meta = oldAttrs.meta // { license = pkgs.lib.licenses.unfree; };
    });

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

    jsonplaceholder = super.jsonplaceholder.override {
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
      nativeBuildInputs = with pkgs; [ nodejs-14_x installShellFiles ];
      postInstall = ''
        # create completions, following upstream procedure https://github.com/joyent/node-manta/blob/v5.2.3/Makefile#L85-L91
        completion_cmds=$(find ./bin -type f -printf "%f\n")

        node ./lib/create_client.js
        for cmd in $completion_cmds; do
          installShellCompletion --cmd $cmd --bash <(./bin/$cmd --completion)
        done
      '';
    };

    markdownlint-cli = super.markdownlint-cli.override (oldAttrs: {
      meta = oldAttrs.meta // { mainProgram = "markdownlint"; };
    });

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

    near-cli = super.near-cli.override {
      nativeBuildInputs = with pkgs; [
        libusb1
        nodePackages.prebuild-install
        nodePackages.node-gyp-build
        pkg-config
      ];
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

    node-inspector = super.node-inspector.override (oldAttrs: {
      buildInputs = [ self.node-pre-gyp ];
      meta = oldAttrs.meta // { broken = since "10"; };
    });

    node-red = super.node-red.override {
      buildInputs = [ self.node-pre-gyp ];
    };

    node2nix = super.node2nix.override {
      buildInputs = [ pkgs.makeWrapper ];
      # We need to use master because of a fix that replaces git:// url to https://.
      src = fetchFromGitHub {
        owner = "svanderburg";
        repo = "node2nix";
        rev = "68f5735f9a56737e3fedceb182705985e3ab8799";
        sha256 = "sha256-NK6gDTkGx0GG7yPTwgtFC4ttQZPfcLaLp8W8OOMO6bg=";
      };

      postInstall = ''
        wrapProgram "$out/bin/node2nix" --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nix ]}
      '';
    };

    parcel = super.parcel.override {
      buildInputs = [ self.node-gyp-build ];
      preRebuild = ''
        sed -i -e "s|#!/usr/bin/env node|#! ${pkgs.nodejs}/bin/node|" node_modules/node-gyp-build/bin.js
      '';
    };

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

    postcss-cli = super.postcss-cli.override (oldAttrs: {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/postcss" \
          --prefix NODE_PATH : ${self.postcss}/lib/node_modules \
          --prefix NODE_PATH : ${self.autoprefixer}/lib/node_modules
        ln -s '${self.postcss}/lib/node_modules/postcss' "$out/lib/node_modules/postcss"
      '';
      passthru.tests = {
        simple-execution = pkgs.callPackage ./package-tests/postcss-cli.nix {
          inherit (self) postcss-cli;
        };
      };
      meta = oldAttrs.meta // {
        mainProgram = "postcss";
        maintainers = with lib.maintainers; [ Luflosi ];
      };
    });

    # To update prisma, please first update prisma-engines to the latest
    # version. Then change the correct hash to this package. The PR should hold
    # two commits: one for the engines and the other one for the node package.
    prisma = super.prisma.override rec {
      nativeBuildInputs = [ pkgs.makeWrapper ];

      inherit (pkgs.prisma-engines) version;

      src = fetchurl {
        url = "https://registry.npmjs.org/prisma/-/prisma-${version}.tgz";
        sha512 = "sha512-l9MOgNCn/paDE+i1K2fp9NZ+Du4trzPTJsGkaQHVBufTGqzoYHuNk8JfzXuIn0Gte6/ZjyKj652Jq/Lc1tp2yw==";
      };
      postInstall = with pkgs; ''
        wrapProgram "$out/bin/prisma" \
          --set PRISMA_MIGRATION_ENGINE_BINARY ${prisma-engines}/bin/migration-engine \
          --set PRISMA_QUERY_ENGINE_BINARY ${prisma-engines}/bin/query-engine \
          --set PRISMA_QUERY_ENGINE_LIBRARY ${lib.getLib prisma-engines}/lib/libquery_engine.node \
          --set PRISMA_INTROSPECTION_ENGINE_BINARY ${prisma-engines}/bin/introspection-engine \
          --set PRISMA_FMT_BINARY ${prisma-engines}/bin/prisma-fmt
      '';

      passthru.tests = {
        simple-execution = pkgs.callPackage ./package-tests/prisma.nix {
          inherit (self) prisma;
        };
      };
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

    ssb-server = super.ssb-server.override (oldAttrs: {
      buildInputs = [ pkgs.automake pkgs.autoconf self.node-gyp-build ];
      meta = oldAttrs.meta // { broken = since "10"; };
    });

    stf = super.stf.override (oldAttrs: {
      meta = oldAttrs.meta // { broken = since "10"; };
    });

    tailwindcss = super.tailwindcss.override {
      plugins = [ ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        nodePath=""
        for p in "$out" "${self.postcss}" $plugins; do
          nodePath="$nodePath''${nodePath:+:}$p/lib/node_modules"
        done
        wrapProgram "$out/bin/tailwind" \
          --prefix NODE_PATH : "$nodePath"
        wrapProgram "$out/bin/tailwindcss" \
          --prefix NODE_PATH : "$nodePath"
        unset nodePath
      '';
      passthru.tests = {
        simple-execution = pkgs.callPackage ./package-tests/tailwindcss.nix { inherit (self) tailwindcss; };
      };
    };

    teck-programmer = super.teck-programmer.override {
      nativeBuildInputs = [ self.node-gyp-build ];
      buildInputs = [ pkgs.libusb1 ];
    };

    tedicross = super."tedicross-git+https://github.com/TediCross/TediCross.git#v0.8.7".override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        makeWrapper '${nodejs}/bin/node' "$out/bin/tedicross" \
          --add-flags "$out/lib/node_modules/tedicross/main.js"
      '';
    };

    thelounge = super.thelounge.override (oldAttrs: {
      buildInputs = [ self.node-pre-gyp ];
      postInstall = ''
        echo /var/lib/thelounge > $out/lib/node_modules/thelounge/.thelounge_home
        patch -d $out/lib/node_modules/thelounge -p1 < ${./thelounge-packages-path.patch}
      '';
      passthru.tests = { inherit (nixosTests) thelounge; };
      meta = oldAttrs.meta // { maintainers = with lib.maintainers; [ winter ]; };
    });

    thelounge-plugin-closepms = super.thelounge-plugin-closepms.override {
      nativeBuildInputs = [ self.node-pre-gyp ];
    };

    thelounge-theme-flat-blue = super.thelounge-theme-flat-blue.override {
      nativeBuildInputs = [ self.node-pre-gyp ];
    };

    thelounge-theme-flat-dark = super.thelounge-theme-flat-dark.override {
      nativeBuildInputs = [ self.node-pre-gyp ];
    };

    triton = super.triton.override {
      nativeBuildInputs = [ pkgs.installShellFiles ];
      postInstall = ''
        installShellCompletion --cmd triton --bash <($out/bin/triton completion)
      '';
    };

    ts-node = super.ts-node.override (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/ts-node" \
        --prefix NODE_PATH : ${self.typescript}/lib/node_modules
      '';
    });

    tsun = super.tsun.override (oldAttrs: {
      buildInputs = oldAttrs.buildInputs ++ [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/tsun" \
        --prefix NODE_PATH : ${self.typescript}/lib/node_modules
      '';
    });

    typescript = super.typescript.override (oldAttrs: {
      meta = oldAttrs.meta // { mainProgram = "tsc"; };
    });

    typescript-language-server = super.typescript-language-server.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/typescript-language-server" \
          --suffix PATH : ${pkgs.lib.makeBinPath [ self.typescript ]}
      '';
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

    webtorrent-cli = super.webtorrent-cli.override {
      buildInputs = [ self.node-gyp-build ];
    };

    yaml-language-server = super.yaml-language-server.override {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postInstall = ''
        wrapProgram "$out/bin/yaml-language-server" \
        --prefix NODE_PATH : ${self.prettier}/lib/node_modules
      '';
    };
  };
in self
