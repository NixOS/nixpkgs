pkgs: lib: self: super:

### Deprecated aliases - for backward compatibility
###
### !!! NOTE !!!
### Use `./remove-attr.py [attrname]` in this directory to remove your alias
### from the `nodePackages` set without regenerating the entire file.

let
  # Removing recurseForDerivation prevents derivations of aliased attribute
  # set to appear while listing all the packages available.
  removeRecurseForDerivations = alias:
    if alias.recurseForDerivations or false
    then lib.removeAttrs alias ["recurseForDerivations"]
    else alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias:
    if lib.isDerivation alias then
      lib.dontDistribute alias
    else alias;

  # Make sure that we are not shadowing something from node-packages.nix.
  checkInPkgs = n: alias:
    if builtins.hasAttr n super
    then throw "Alias ${n} is still in node-packages.nix"
    else alias;

  mapAliases = aliases:
    lib.mapAttrs (n: alias:
      removeDistribute
        (removeRecurseForDerivations
          (checkInPkgs n alias)))
      aliases;
in

mapAliases {
  "@antora/cli" = pkgs.antora; # Added 2023-05-06
  "@astrojs/language-server" = pkgs.astro-language-server; # Added 2024-02-12
  "@bitwarden/cli" = pkgs.bitwarden-cli; # added 2023-07-25
  "@emacs-eask/cli" = pkgs.eask; # added 2023-08-17
  "@forge/cli" = throw "@forge/cli was removed because it was broken"; # added 2023-09-20
  "@githubnext/github-copilot-cli" = pkgs.github-copilot-cli; # Added 2023-05-02
  "@google/clasp" = pkgs.google-clasp; # Added 2023-05-07
  "@maizzle/cli" = pkgs.maizzle; # added 2023-08-17
  "@medable/mdctl-cli" = throw "@medable/mdctl-cli was removed because it was broken"; # added 2023-08-21
  "@mermaid-js/mermaid-cli" = pkgs.mermaid-cli; # added 2023-10-01
  "@nerdwallet/shepherd" = pkgs.shepherd; # added 2023-09-30
  "@nestjs/cli" = pkgs.nest-cli; # Added 2023-05-06
  "@tailwindcss/language-server" = pkgs.tailwindcss-language-server; # added 2024-01-22
  "@volar/vue-language-server" = pkgs.vue-language-server; # added 2024-06-15
  "@vue/language-server" = pkgs.vue-language-server; # added 2024-06-15
  "@withgraphite/graphite-cli" = pkgs.graphite-cli; # added 2024-01-25
  "@zwave-js/server" = pkgs.zwave-js-server; # Added 2023-09-09
  alloy = pkgs.titanium-alloy; # added 2023-08-17
  antennas = pkgs.antennas; # added 2023-07-30
  inherit (pkgs) autoprefixer; # added 2024-06-25
  inherit (pkgs) asar; # added 2023-08-26
  inherit (pkgs) auto-changelog; # added 2024-06-25
  inherit (pkgs) aws-azure-login; # added 2023-09-30
  balanceofsatoshis = pkgs.balanceofsatoshis; # added 2023-07-31
  inherit (pkgs) bash-language-server; # added 2024-06-07
  bibtex-tidy = pkgs.bibtex-tidy; # added 2023-07-30
  bitwarden-cli = pkgs.bitwarden-cli; # added 2023-07-25
  inherit (pkgs) btc-rpc-explorer; # added 2023-08-17
  inherit (pkgs) carbon-now-cli; # added 2023-08-17
  inherit (pkgs) carto; # added 2023-08-17
  castnow = pkgs.castnow; # added 2023-07-30
  inherit (pkgs) clean-css-cli; # added 2023-08-18
  inherit (pkgs) clubhouse-cli; # added 2023-08-18
  inherit (pkgs) coc-clangd; # added 2024-06-29
  inherit (pkgs) coc-diagnostic; # added 2024-06-29
  coc-imselect = throw "coc-imselect was removed because it was broken"; # added 2023-08-21
  inherit (pkgs) coc-pyright; # added 2024-07-14
  coinmon = throw "coinmon was removed since it was abandoned upstream"; # added 2024-03-19
  coffee-script = pkgs.coffeescript; # added 2023-08-18
  inherit (pkgs) concurrently; # added 2024-08-05
  inherit (pkgs) configurable-http-proxy; # added 2023-08-19
  inherit (pkgs) cordova; # added 2023-08-18
  inherit (pkgs) create-react-app; # added 2023-09-25
  dat = throw "dat was removed because it was broken"; # added 2023-08-21
  inherit (pkgs) degit; # added 2023-08-18
  inherit (pkgs) diagnostic-languageserver; # added 2024-06-25
  inherit (pkgs) dockerfile-language-server-nodejs; # added 2023-08-18
  inherit (pkgs) dotenv-cli; # added 2024-06-26
  eask = pkgs.eask; # added 2023-08-17
  inherit (pkgs.elmPackages) elm-test;
  inherit (pkgs) eslint; # Added 2024-08-28
  inherit (pkgs) eslint_d; # Added 2023-05-26
  inherit (pkgs) firebase-tools; # added 2023-08-18
  inherit (pkgs) fixjson; # added 2024-06-26
  flood = pkgs.flood; # Added 2023-07-25
  generator-code = throw "generator-code was removed because it provides no executable"; # added 2023-09-24
  inherit (pkgs) git-run; # added 2024-06-26
  git-ssb = throw "git-ssb was removed because it was broken"; # added 2023-08-21
  inherit (pkgs) git-standup; # added 2024-06-26
  inherit (pkgs) gitmoji-cli; # added 2023-09-23
  glob = pkgs.node-glob; # added 2023-08-18
  inherit (pkgs) get-graphql-schema; # added 2024-06-26
  inherit (pkgs) gqlint; # added 2023-08-19
  inherit (pkgs) gramma; # added 2024-06-26
  grammarly-languageserver = throw "grammarly-languageserver was removed because it requires EOL Node.js 16"; # added 2024-07-15
  inherit (pkgs) graphite-cli; # added 2024-01-25
  inherit (pkgs) graphqurl; # added 2023-08-19
  gtop = pkgs.gtop; # added 2023-07-31
  hs-client = pkgs.hsd; # added 2023-08-20
  inherit (pkgs) hsd; # added 2023-08-19
  inherit (pkgs) html-minifier; # added 2023-08-19
  inherit (pkgs) htmlhint; # added 2023-08-19
  inherit (pkgs) http-server; # added 2024-01-20
  hueadm = pkgs.hueadm; # added 2023-07-31
  inherit (pkgs) hyperpotamus; # added 2023-08-19
  immich = pkgs.immich-cli; # added 2023-08-19
  indium = throw "indium was removed because it was broken"; # added 2023-08-19
  inliner = throw "inliner was removed because it was abandoned upstream"; # added 2024-08-23
  inherit (pkgs) intelephense; # added 2024-08-31
  ionic = throw "ionic was replaced by @ionic/cli"; # added 2023-08-19
  inherit (pkgs) jake; # added 2023-08-19
  inherit (pkgs) javascript-typescript-langserver; # added 2023-08-19
  karma = pkgs.karma-runner; # added 2023-07-29
  leetcode-cli = self.vsc-leetcode-cli; # added 2023-08-31
  inherit (pkgs) lv_font_conv; # added 2024-06-28
  manta = pkgs.node-manta; # Added 2023-05-06
  inherit (pkgs) markdown-link-check; # added 2024-06-28
  markdownlint-cli = pkgs.markdownlint-cli; # added 2023-07-29
  inherit (pkgs) markdownlint-cli2; # added 2023-08-22
  inherit (pkgs) mathjax-node-cli; # added 2023-11-02
  mdctl-cli = self."@medable/mdctl-cli"; # added 2023-08-21
  inherit (pkgs) mermaid-cli; # added 2023-10-01
  musescore-downloader = pkgs.dl-librescore; # added 2023-08-19
  inherit (pkgs) near-cli; # added 2023-09-09
  node-inspector = throw "node-inspector was removed because it was broken"; # added 2023-08-21
  inherit (pkgs) node-gyp; # added 2024-08-13
  inherit (pkgs) node-pre-gyp; # added 2024-08-05
  inherit (pkgs) nodemon; # added 2024-06-28
  inherit (pkgs) npm-check-updates; # added 2023-08-22
  ocaml-language-server = throw "ocaml-language-server was removed because it was abandoned upstream"; # added 2023-09-04
  parcel-bundler = self.parcel; # added 2023-09-04
  pkg = pkgs.vercel-pkg; # added 2023-10-04
  inherit (pkgs) pm2; # added 2024-01-22
  inherit (pkgs) pnpm; # added 2024-06-26
  prettier_d_slim = pkgs.prettier-d-slim; # added 2023-09-14
  inherit (pkgs) prisma; # added 2024-08-31
  inherit (pkgs) pxder; # added 2023-09-26
  inherit (pkgs) quicktype; # added 2023-09-09
  react-native-cli = throw "react-native-cli was removed because it was deprecated"; # added 2023-09-25
  inherit (pkgs) react-static; # added 2023-08-21
  react-tools = throw "react-tools was removed because it was deprecated"; # added 2023-09-25
  readability-cli = pkgs.readability-cli; # Added 2023-06-12
  inherit (pkgs) redoc-cli; # added 2023-09-12
  reveal-md = pkgs.reveal-md; # added 2023-07-31
  inherit (pkgs) rtlcss; # added 2023-08-29
  s3http = throw "s3http was removed because it was abandoned upstream"; # added 2023-08-18
  inherit (pkgs) serverless; # Added 2023-11-29
  inherit (pkgs) snyk; # Added 2023-08-30
  "@squoosh/cli" = throw "@squoosh/cli was removed because it was abandoned upstream"; # added 2023-09-02
  ssb-server = throw "ssb-server was removed because it was broken"; # added 2023-08-21
  stf = throw "stf was removed because it was broken"; # added 2023-08-21
  inherit (pkgs) stylelint; # added 2023-09-13
  surge = pkgs.surge-cli; # Added 2023-09-08
  inherit (pkgs) svelte-language-server; # Added 2024-05-12
  swagger = throw "swagger was removed because it was broken and abandoned upstream"; # added 2023-09-09
  teck-programmer = throw "teck-programmer was removed because it was broken and unmaintained"; # added 2024-08-23
  tedicross = throw "tedicross was removed because it was broken"; # added 2023-09-09
  inherit (pkgs) terser; # Added 2023-08-31
  inherit (pkgs) textlint; # Added 2024-05-13
  textlint-plugin-latex = throw "textlint-plugin-latex was removed because it is unmaintained for years. Please use textlint-plugin-latex2e instead."; # Added 2024-05-17
  inherit (pkgs) textlint-rule-abbr-within-parentheses; # Added 2024-05-17
  inherit (pkgs) textlint-rule-alex; # Added 2024-05-16
  inherit (pkgs) textlint-rule-common-misspellings; # Added 2024-05-25
  inherit (pkgs) textlint-rule-diacritics; # Added 2024-05-16
  inherit (pkgs) textlint-rule-en-max-word-count; # Added 2024-05-17
  inherit (pkgs) textlint-rule-max-comma; # Added 2024-05-15
  inherit (pkgs) textlint-rule-no-start-duplicated-conjunction; # Added 2024-05-17
  inherit (pkgs) textlint-rule-period-in-list-item; # Added 2024-05-17
  inherit (pkgs) textlint-rule-stop-words; # Added 2024-05-17
  inherit (pkgs) textlint-rule-terminology; # Added 2024-05-17
  inherit (pkgs) textlint-rule-unexpanded-acronym; # Added 2024-05-17
  inherit (pkgs) textlint-rule-write-good; # Added 2024-05-16
  thelounge = pkgs.thelounge; # Added 2023-05-22
  three = throw "three was removed because it was no longer needed"; # Added 2023-09-08
  inherit (pkgs) titanium; # added 2023-08-17
  triton = pkgs.triton; # Added 2023-05-06
  typescript = pkgs.typescript; # Added 2023-06-21
  inherit (pkgs) typescript-language-server; # added 2024-02-27
  inherit (pkgs) uglify-js; # added 2024-06-15
  inherit (pkgs) undollar; # added 2024-06-29
  inherit (pkgs) ungit; # added 2023-08-20
  inherit (pkgs) vim-language-server; # added 2024-06-25
  inherit (pkgs) vsc-leetcode-cli; # Added 2023-08-30
  vscode-css-languageserver-bin = throw "vscode-css-languageserver-bin has been removed since the upstream repository is archived; consider using vscode-langservers-extracted instead."; # added 2024-06-26
  vscode-html-languageserver-bin = throw "vscode-html-languageserver-bin has been removed since the upstream repository is archived; consider using vscode-langservers-extracted instead."; # added 2024-06-26
  vscode-json-languageserver-bin = throw "vscode-json-languageserver-bin has been removed since the upstream repository is archived; consider using vscode-langservers-extracted instead."; # added 2024-06-26
  vscode-langservers-extracted = pkgs.vscode-langservers-extracted; # Added 2023-05-27
  vue-language-server = self.vls; # added 2023-08-20
  vue-cli = throw "vue-cli has been removed since upstream no longer recommends using it; consider using create-vue and the new Vite-based tooling instead."; # added 2024-07-12
  inherit (pkgs) web-ext; # added 2023-08-20
  inherit (pkgs) wrangler; # added 2024-07-01
  inherit (pkgs) write-good; # added 2023-08-20
  inherit (pkgs) yaml-language-server; # added 2023-09-05
  inherit (pkgs) yarn; # added 2024-08-13
  inherit (pkgs) yo; # added 2023-08-20
  zx = pkgs.zx; # added 2023-08-01
}
