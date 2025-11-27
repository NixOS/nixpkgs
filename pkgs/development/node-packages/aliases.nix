pkgs: lib: self: super:

### Deprecated aliases - for backward compatibility
###
### !!! NOTE !!!
### Use `./remove-attr.py [attrname]` in this directory to remove your alias
### from the `nodePackages` set without regenerating the entire file.

let
  # Removing recurseForDerivation prevents derivations of aliased attribute
  # set to appear while listing all the packages available.
  removeRecurseForDerivations =
    alias:
    if alias.recurseForDerivations or false then
      lib.removeAttrs alias [ "recurseForDerivations" ]
    else
      alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias: if lib.isDerivation alias then lib.dontDistribute alias else alias;

  # Make sure that we are not shadowing something from node-packages.nix.
  checkInPkgs =
    n: alias:
    if builtins.hasAttr n super then throw "Alias ${n} is still in node-packages.nix" else alias;

  mapAliases =
    aliases:
    lib.mapAttrs (
      n: alias: removeDistribute (removeRecurseForDerivations (checkInPkgs n alias))
    ) aliases;
in

mapAliases {
  "@antfu/ni" = pkgs.ni; # Added 2025-11-08
  "@antora/cli" = pkgs.antora; # Added 2023-05-06
  "@astrojs/language-server" = pkgs.astro-language-server; # Added 2024-02-12
  "@babel/cli" =
    throw "@babel/cli was removed because upstream highly suggests installing it in your project instead of globally."; # Added 2025-11-06
  "@bitwarden/cli" = pkgs.bitwarden-cli; # added 2023-07-25
  "@commitlint/cli" = pkgs.commitlint; # Added 2025-11-08
  "@commitlint/config-conventional" =
    throw "@commitlint/config-conventional has been dropped, as it is a library and your JS project should lock it instead."; # added 2024-12-16
  "@emacs-eask/cli" = pkgs.eask; # added 2023-08-17
  "@electron-forge/cli" =
    throw "@electron-forge/cli was removed because upstream suggests that you install it locally in your project instead."; # Added 2025-11-06
  "@forge/cli" = throw "@forge/cli was removed because it was broken"; # added 2023-09-20
  "@gitbeaker/cli" = pkgs.gitbeaker-cli; # Added 2025-10-29
  "@google/clasp" = pkgs.google-clasp; # Added 2023-05-07
  "@maizzle/cli" = pkgs.maizzle; # added 2023-08-17
  "@medable/mdctl-cli" = throw "@medable/mdctl-cli was removed because it was broken"; # added 2023-08-21
  "@mermaid-js/mermaid-cli" = pkgs.mermaid-cli; # added 2023-10-01
  "@nerdwallet/shepherd" = pkgs.shepherd; # added 2023-09-30
  "@nestjs/cli" = pkgs.nest-cli; # Added 2023-05-06
  "@prisma/language-server" = throw "@prisma/language-server has been removed because it was broken"; # added 2025-03-23
  "@shopify/cli" = throw "@shopify/cli has been removed because it was broken"; # added 2025-03-12
  "@tailwindcss/language-server" = pkgs.tailwindcss-language-server; # added 2024-01-22
  "@uppy/companion" = pkgs.uppy-companion; # Added 2025-11-01
  "@volar/vue-language-server" = pkgs.vue-language-server; # added 2024-06-15
  "@vue/language-server" = pkgs.vue-language-server; # added 2024-06-15
  "@webassemblyjs/cli-1.11.1" = pkgs.webassemblyjs-cli; # Added 2025-11-06
  "@webassemblyjs/repl-1.11.1" = pkgs.webassemblyjs-repl; # Added 2025-11-06
  "@webassemblyjs/wasm-strip" =
    "@webassemblyjs/wasm-strip has been removed because it was deprecated by upstream. Consider using wabt instead"; # Added 2025-11-06
  "@webassemblyjs/wasm-text-gen-1.11.1" = pkgs.wasm-text-gen; # Added 2025-11-06
  "@webassemblyjs/wast-refmt-1.11.1" = pkgs.wast-refmt; # Added 2025-11-06
  "@withgraphite/graphite-cli" = pkgs.graphite-cli; # added 2024-01-25
  "@yaegassy/coc-nginx" = pkgs.coc-nginx; # Added 2025-11-08
  "@zwave-js/server" = pkgs.zwave-js-server; # Added 2023-09-09
  audiosprite = throw "'audiosprite' has been removed because it was abandoned upstream"; # Added 2025-11-14
  inherit (pkgs) autoprefixer; # added 2024-06-25
  inherit (pkgs) asar; # added 2023-08-26
  inherit (pkgs) auto-changelog; # added 2024-06-25
  inherit (pkgs) aws-azure-login; # added 2023-09-30
  awesome-lint = throw "'awesome-lint' has been removed because it was unmaintainable in nixpkgs"; # Added 2025-11-17
  balanceofsatoshis = pkgs.balanceofsatoshis; # added 2023-07-31
  inherit (pkgs) bash-language-server; # added 2024-06-07
  bibtex-tidy = pkgs.bibtex-tidy; # added 2023-07-30
  bitwarden-cli = pkgs.bitwarden-cli; # added 2023-07-25
  bower = throw "bower was removed because it was deprecated"; # added 2025-09-17
  inherit (pkgs) bower2nix; # added 2024-08-23
  inherit (pkgs) btc-rpc-explorer; # added 2023-08-17
  inherit (pkgs) carbon-now-cli; # added 2023-08-17
  inherit (pkgs) carto; # added 2023-08-17
  castnow = pkgs.castnow; # added 2023-07-30
  inherit (pkgs) cdk8s-cli; # Added 2025-11-10
  inherit (pkgs) cdktf-cli; # added 2025-10-02
  inherit (pkgs) clean-css-cli; # added 2023-08-18
  clipboard-cli = throw "'clipboard-cli' has been removed because it was unmaintainable in nixpkgs"; # Added 2025-11-17
  inherit (pkgs) coc-clangd; # added 2024-06-29
  inherit (pkgs) coc-cmake; # Added 2025-11-05
  inherit (pkgs) coc-css; # added 2024-06-29
  inherit (pkgs) coc-diagnostic; # added 2024-06-29
  inherit (pkgs) coc-docker; # added 2025-10-01
  inherit (pkgs) coc-emmet; # Added 2025-11-05
  inherit (pkgs) coc-eslint; # Added 2025-11-05;
  inherit (pkgs) coc-explorer; # added 2025-10-01
  inherit (pkgs) coc-flutter; # Added 2025-11-05
  inherit (pkgs) coc-git; # added 2025-10-01
  inherit (pkgs) coc-haxe; # Added 2025-11-05
  inherit (pkgs) coc-highlight; # Added 2025-11-05
  inherit (pkgs) coc-html; # Added 2025-11-05
  coc-imselect = throw "coc-imselect was removed because it was broken"; # added 2023-08-21
  inherit (pkgs) coc-java; # Added 2025-11-05
  inherit (pkgs) coc-jest; # Added 2025-11-05
  inherit (pkgs) coc-json; # Added 2025-11-05
  inherit (pkgs) coc-lists; # Added 2025-11-05
  coc-ltex = throw "'coc-ltex' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  inherit (pkgs) coc-markdownlint; # Added 2025-11-05
  coc-metals = throw "coc-metals was removed because it was deprecated upstream. vimPlugins.nvim-metals is its official replacement."; # Added 2024-10-16
  inherit (pkgs) coc-pairs; # added 2025-11-05
  inherit (pkgs) coc-prettier; # added 2025-11-05
  inherit (pkgs) coc-pyright; # added 2024-07-14
  coc-python = throw "coc-python was removed because it was abandoned upstream on 2020-12-24. Upstream now recommends using coc-pyright or coc-jedi instead."; # added 2024-10-15
  inherit (pkgs) coc-r-lsp; # added 2025-11-05
  coc-rls = throw "coc-rls was removed because rls was deprecated in 2022. You should use coc-rust-analyzer instead, as rust-analyzer is maintained."; # added 2025-10-01
  inherit (pkgs) coc-rust-analyzer; # added 2025-11-05
  inherit (pkgs) coc-sh; # added 2025-10-02
  inherit (pkgs) coc-smartf; # Added 2025-11-05
  inherit (pkgs) coc-snippets; # Added 2025-11-05
  inherit (pkgs) coc-solargraph; # Added 2025-11-05
  inherit (pkgs) coc-spell-checker; # added 2025-10-01
  inherit (pkgs) coc-sqlfluff; # Added 2025-11-05
  inherit (pkgs) coc-stylelint; # Added 2025-11-05
  inherit (pkgs) coc-sumneko-lua; # Added 2025-11-05
  inherit (pkgs) coc-tabnine; # Added 2025-11-05
  inherit (pkgs) coc-texlab; # Added 2025-11-05
  inherit (pkgs) coc-toml;
  coc-tslint = throw "coc-tslint was removed because it was deprecated upstream; coc-eslint offers comparable features for eslint, which replaced tslint"; # Added 2024-10-18
  coc-tslint-plugin = throw "coc-tslint-plugin was removed because it was deprecated upstream; coc-eslint offers comparable features for eslint, which replaced tslint"; # Added 2024-10-18
  coc-ultisnips = throw "'coc-ultisnips' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  coc-vetur = throw "coc-vetur was removed because vetur was deprecated by Vue in favor of volar. Use coc-volar instead, which supports Vue 3"; # added 2025-10-01
  inherit (pkgs) coc-vimlsp; # Added 2025-11-05
  inherit (pkgs) coc-vimtex; # Added 2025-11-05
  inherit (pkgs) coc-wxml; # Added 2025-11-05
  inherit (pkgs) coc-yaml; # Added 2025-11-05
  inherit (pkgs) coc-yank; # Added 2025-11-05
  inherit (pkgs) code-theme-converter; # Added 2025-11-08
  coinmon = throw "coinmon was removed since it was abandoned upstream"; # added 2024-03-19
  coffee-script = pkgs.coffeescript; # added 2023-08-18
  inherit (pkgs) concurrently; # added 2024-08-05
  inherit (pkgs) configurable-http-proxy; # added 2023-08-19
  inherit (pkgs) conventional-changelog-cli; # Added 2025-11-08
  copy-webpack-plugin = throw "copy-webpack-plugin was removed because it is a JS library, so your project should lock it with a JS package manager instead."; # Added 2024-12-16
  inherit (pkgs) cordova; # added 2023-08-18
  cpy-cli = throw "'cpy-cli' has been removed because it was unmaintainable in nixpkgs"; # Added 2025-11-17
  create-cycle-app = throw "create-cycle-app has been removed because it is unmaintained and has issues installing with recent nodejs versions."; # Added 2025-11-01
  create-react-native-app = throw "create-react-native-app was removed because it was deprecated. Upstream suggests using a framework for React Native."; # added 2024-12-08
  inherit (pkgs) cspell;
  csslint = throw "'csslint' has been removed as upstream considers it abandoned."; # Addeed 2025-11-07
  dat = throw "dat was removed because it was broken"; # added 2023-08-21
  inherit (pkgs) degit; # added 2023-08-18
  dhcp = throw "'dhcp' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  inherit (pkgs) diagnostic-languageserver; # added 2024-06-25
  inherit (pkgs) diff2html-cli; # Added 2025-11-08
  inherit (pkgs) dockerfile-language-server-nodejs; # added 2023-08-18
  inherit (pkgs) dotenv-cli; # added 2024-06-26
  eask = pkgs.eask; # added 2023-08-17
  inherit (pkgs.elmPackages) elm-test;
  inherit (pkgs.elmPackages) elm-review;
  elm-oracle = throw "'elm-oracle' has been removed, since it doesn't work with modern versions of Elm."; # Added 2025-11-07
  emoj = throw "'emoj' has been removed because it was unmaintainable in nixpkgs"; # Added 2025-11-17
  emojione = throw "emojione was archived and abandoned upstream, so it has been removed"; # Added 2025-11-06
  escape-string-regexp = throw "escape-string-regexp was removed because it provides no executable"; # added 2025-03-12
  inherit (pkgs) eslint; # Added 2024-08-28
  inherit (pkgs) eslint_d; # Added 2023-05-26
  inherit (pkgs) eas-cli; # added 2025-01-08
  expo-cli = throw "expo-cli was removed because it was deprecated upstream. Use `npx expo` or eas-cli instead."; # added 2024-12-02
  fast-cli = throw "'fast-cli' has been removed because it was unmaintainable in nixpkgs"; # Added 2025-11-17
  inherit (pkgs) fauna-shell; # Added 2025-11-27
  inherit (pkgs) firebase-tools; # added 2023-08-18
  inherit (pkgs) fixjson; # added 2024-06-26
  fkill-cli = throw "'fkill-cli' has been removed because it was unmaintainable in nixpkgs"; # Added 2025-11-17
  fleek-cli = throw "'fleek-cli' was removed because the upstream source code repo has been deleted."; # Added 2025-11-07
  flood = pkgs.flood; # Added 2023-07-25
  forever = throw "'forever' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  inherit (pkgs) fx; # Added 2025-11-06
  ganache = throw "ganache was removed because it was deprecated upstream"; # added 2024-12-02
  inherit (pkgs) gatsby-cli; # Added 2025-11-05
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
  inherit (pkgs) graphql-language-service-cli; # added 2025-03-17
  inherit (pkgs) graphqurl; # added 2023-08-19
  gtop = pkgs.gtop; # added 2023-07-31
  gulp = self.gulp-cli; # Added 2025-11-04
  he = throw "'he' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  hs-airdrop = throw "'hs-airdrop' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  hs-client = pkgs.hsd; # added 2023-08-20
  inherit (pkgs) hsd; # added 2023-08-19
  inherit (pkgs) html-minifier; # added 2023-08-19
  inherit (pkgs) htmlhint; # added 2023-08-19
  inherit (pkgs) http-server; # added 2024-01-20
  hueadm = pkgs.hueadm; # added 2023-07-31
  inherit (pkgs) hyperpotamus; # added 2023-08-19
  ijavascript = throw "ijavascript has been removed because it was broken"; # added 2025-03-18
  imapnotify = throw "'imapnotify' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  immich = pkgs.immich-cli; # added 2023-08-19
  indium = throw "indium was removed because it was broken"; # added 2023-08-19
  inliner = throw "inliner was removed because it was abandoned upstream"; # added 2024-08-23
  inherit (pkgs) intelephense; # added 2024-08-31
  insect = throw "insect was removed becuase it was deprecated by upstream. Use numbat instead."; # added 2024-12-02
  ionic = throw "ionic was replaced by @ionic/cli"; # added 2023-08-19
  inherit (pkgs) jake; # added 2023-08-19
  inherit (pkgs) javascript-typescript-langserver; # added 2023-08-19
  inherit (pkgs) js-beautify; # Added 2025-11-06
  inherit (pkgs) jshint; # Added 2025-11-06
  json = throw "'json' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  inherit (pkgs) json-diff; # Added 2025-11-07
  jsonlint = throw "'jsonlint' has been removed because it is unmaintained upstream"; # Added 2025-11-10
  inherit (pkgs) jsonplaceholder; # Added 2025-11-04
  json-refs = throw "'json-refs' has been removed because it is unmaintained and has several known vulnerable dependencies"; # Added 2025-11-10
  inherit (pkgs) json-server; # Added 2025-11-06
  joplin = pkgs.joplin-cli; # Added 2025-11-02
  inherit (pkgs) kaput-cli; # added 2024-12-03
  karma = pkgs.karma-runner; # added 2023-07-29
  inherit (pkgs) katex; # Added 2025-11-08
  keyoxide = pkgs.keyoxide-cli; # Added 2025-10-20
  leetcode-cli = self.vsc-leetcode-cli; # added 2023-08-31
  inherit (pkgs) lerna; # added 2025-02-12
  less = pkgs.lessc; # added 2024-06-15
  less-plugin-clean-css = pkgs.lessc.plugins.clean-css; # added 2024-06-15
  livedown = throw "'livedown' has been removed because it was unmaintained"; # Added 2025-11-10
  live-server = throw "'live-server' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  inherit (pkgs) localtunnel; # Added 2025-11-08
  lodash = throw "lodash was removed because it provides no executable"; # added 2025-03-18
  lua-fmt = throw "'lua-fmt' has been removed because it has critical bugs that break formatting"; # Added 2025-11-07
  inherit (pkgs) lv_font_conv; # added 2024-06-28
  madoko = throw "'madoko' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  makam = throw "'makam' has been removed because it is unmaintained upstream"; # Added 2025-11-14
  manta = pkgs.node-manta; # Added 2023-05-06
  inherit (pkgs) markdown-link-check; # added 2024-06-28
  markdownlint-cli = pkgs.markdownlint-cli; # added 2023-07-29
  inherit (pkgs) markdownlint-cli2; # added 2023-08-22
  inherit (pkgs) mathjax-node-cli; # added 2023-11-02
  mastodon-bot = throw "'mastodon-bot' has been removed because it was archived by upstream in 2021."; # Added 2025-11-07
  mdctl-cli = self."@medable/mdctl-cli"; # added 2023-08-21
  meat = throw "meat was removed because it was abandoned upstream."; # Added 2025-10-20
  inherit (pkgs) mermaid-cli; # added 2023-10-01
  meshcommander = throw "meshcommander was removed because it was abandoned upstream"; # added 2024-12-02
  inherit (pkgs) mocha; # Added 2025-11-04
  multi-file-swagger = throw "'multi-file-swagger' has been removed because it is unmaintained upstream"; # Added 2025-11-10
  musescore-downloader = pkgs.dl-librescore; # added 2023-08-19
  near-cli = throw "'near-cli' has been removed as upstream has deprecated it and archived the source code repo"; # Added 2025-11-10
  neovim = pkgs.neovim-node-client; # added 2024-11-13
  nijs = throw "'nijs' has been removed as it was unmaintained upstream"; # Added 2025-11-14
  node-inspector = throw "node-inspector was removed because it was broken"; # added 2023-08-21
  inherit (pkgs) node-gyp; # added 2024-08-13
  inherit (pkgs) node-pre-gyp; # added 2024-08-05
  inherit (pkgs) node-red; # added 2024-10-06
  inherit (pkgs) nodemon; # added 2024-06-28
  np = throw "'np' has been removed because it was unmaintainable in nixpkgs"; # Added 2025-11-17
  npm = pkgs.nodejs.overrideAttrs (old: {
    meta = old.meta // {
      mainProgram = "npm";
    };
  }); # added 2024-10-04
  inherit (pkgs) npm-check-updates; # added 2023-08-22
  npm-merge-driver = throw "'npm-merge-driver' has been removed, since the upstream repo was archived on Aug 11, 2021"; # Added 2025-11-07
  inherit (pkgs) nrm; # Added 2025-11-08
  ocaml-language-server = throw "ocaml-language-server was removed because it was abandoned upstream"; # added 2023-09-04
  orval = throw "orval has been removed because it was broken"; # added 2025-03-23
  parcel = throw "parcel has been removed because it was broken"; # added 2025-03-12
  parcel-bundler = self.parcel; # added 2023-09-04
  parsoid = throw "The Javascript version of Parsoid has been deprecated by upstream and no longer works with modern MediaWiki versions"; # Added 2025-11-04
  inherit (pkgs) patch-package; # added 2024-06-29
  peerflix = throw "'peerflix' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  inherit (pkgs) peerflix-server; # Added 2025-11-10
  pkg = pkgs.vercel-pkg; # added 2023-10-04
  inherit (pkgs) pm2; # added 2024-01-22
  inherit (pkgs) pnpm; # added 2024-06-26
  poor-mans-t-sql-formatter-cli = throw "'poor-mans-t-sql-formatter-cli' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  postcss-cli = throw "postcss-cli has been removed because it was broken"; # added 2025-03-24
  inherit (pkgs) prettier; # added 2025-05-31
  prettier_d_slim = pkgs.prettier-d-slim; # added 2023-09-14
  prettier-plugin-toml = throw "prettier-plugin-toml was removed because it provides no executable"; # added 2025-03-23
  inherit (pkgs) prisma; # added 2024-08-31
  purty = throw "'purty' has been remved because it was unmaintained upstream"; # Added 2025-11-14
  inherit (pkgs) pxder; # added 2023-09-26
  inherit (pkgs) quicktype; # added 2023-09-09
  react-native-cli = throw "react-native-cli was removed because it was deprecated"; # added 2023-09-25
  react-static = throw "'react-static has been removed because of a lack of upstream maintainance"; # Converted to throw 2025-11-04
  react-tools = throw "react-tools was removed because it was deprecated"; # added 2023-09-25
  readability-cli = pkgs.readability-cli; # Added 2023-06-12
  inherit (pkgs) redoc-cli; # added 2023-09-12
  remod-cli = pkgs.remod; # added 2024-12-04
  "reveal.js" = throw "reveal.js was removed because it provides no executable"; # added 2025-03-23
  reveal-md = pkgs.reveal-md; # added 2023-07-31
  rimraf = throw "rimraf was removed because it is a library, and your project should lock it instead."; # added 2025-05-28
  rollup = throw "rollup has been removed because it was broken"; # added 2025-04-28
  inherit (pkgs) rtlcss; # added 2023-08-29
  s3http = throw "s3http was removed because it was abandoned upstream"; # added 2023-08-18
  inherit (pkgs) serve; # added 2025-08-27
  inherit (pkgs) serverless; # Added 2023-11-29
  shout = throw "shout was removed because it was deprecated upstream in favor of thelounge."; # Added 2024-10-19
  smartdc = throw "'smartdc' was removed because it was unmaintained upstream"; # Added 2025-11-14
  inherit (pkgs) snyk; # Added 2023-08-30
  "socket.io" = throw "socket.io was removed because it provides no executable"; # added 2025-03-23
  speed-test = throw "'speed-test' has been removed because it was broken"; # Added 2025-11-07
  inherit (pkgs) sql-formatter; # added 2024-06-29
  "@squoosh/cli" = throw "@squoosh/cli was removed because it was abandoned upstream"; # added 2023-09-02
  ssb-server = throw "ssb-server was removed because it was broken"; # added 2023-08-21
  stackdriver-statsd-backend = throw "stackdriver-statsd-backend was removed because Stackdriver is now discontinued"; # added 2024-12-02
  stf = throw "stf was removed because it was broken"; # added 2023-08-21
  inherit (pkgs) stylelint; # added 2023-09-13
  surge = pkgs.surge-cli; # Added 2023-09-08
  inherit (pkgs) svelte-check; # Added 2025-11-10
  inherit (pkgs) svelte-language-server; # Added 2024-05-12
  inherit (pkgs) svgo; # added 2025-08-24
  swagger = throw "swagger was removed because it was broken and abandoned upstream"; # added 2023-09-09
  inherit (pkgs) tailwindcss; # added 2024-12-04
  teck-programmer = throw "teck-programmer was removed because it was broken and unmaintained"; # added 2024-08-23
  tedicross = throw "tedicross was removed because it was broken"; # added 2023-09-09
  tern = throw "'tern' was removed because it has been unmaintained upstream for several years"; # Added 2025-11-07
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
  thelounge-plugin-closepms = throw "thelounge-plugin-closepms has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-plugin-giphy = throw "thelounge-plugin-giphy has been removed because thelounge moved out of nodePackages"; # added 2025-03-12
  thelounge-plugin-shortcuts = throw "thelounge-plugin-shortcuts has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-abyss = throw "thelounge-theme-abyss has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-amoled = throw "thelounge-theme-amoled has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-amoled-sourcecodepro = throw "thelounge-theme-amoled-sourcecodepro has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-bdefault = throw "thelounge-theme-bdefault has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-bmorning = throw "thelounge-theme-bmorning has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-chord = throw "thelounge-theme-chord has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-classic = throw "thelounge-theme-classic has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-common = throw "thelounge-theme-common has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-crypto = throw "thelounge-theme-crypto has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-discordapp = throw "thelounge-theme-discordapp has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-dracula = throw "thelounge-theme-dracula has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-dracula-official = throw "thelounge-theme-dracula-official has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-flat-blue = throw "thelounge-theme-flat-blue has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-flat-dark = throw "thelounge-theme-flat-dark has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-gruvbox = throw "thelounge-theme-gruvbox has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-hexified = throw "thelounge-theme-hexified has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-ion = throw "thelounge-theme-ion has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-light = throw "thelounge-theme-light has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-midnight = throw "thelounge-theme-midnight has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-mininapse = throw "thelounge-theme-mininapse has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-monokai-console = throw "thelounge-theme-monokai-console has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-mortified = throw "thelounge-theme-mortified has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-neuron-fork = throw "thelounge-theme-neuron-fork has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-new-morning = throw "thelounge-theme-new-morning has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-new-morning-compact = throw "thelounge-theme-new-morning-compact has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-nologo = throw "thelounge-theme-nologo has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-nord = throw "thelounge-theme-nord has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-onedark = throw "thelounge-theme-onedark has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-purplenight = throw "thelounge-theme-purplenight has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-scoutlink = throw "thelounge-theme-scoutlink has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-seraphimrp = throw "thelounge-theme-seraphimrp has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-solarized = throw "thelounge-theme-solarized has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-solarized-fork-monospace = throw "thelounge-theme-solarized-fork-monospace has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-zenburn = throw "thelounge-theme-zenburn has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-zenburn-monospace = throw "thelounge-theme-zenburn-monospace has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  thelounge-theme-zenburn-sourcecodepro = throw "thelounge-theme-zenburn-sourcecodepro has been removed because thelounge was moved out of nodePackages"; # added 2025-03-12
  three = throw "three was removed because it was no longer needed"; # Added 2023-09-08
  inherit (pkgs) tiddlywiki; # Added 2025-11-10
  triton = pkgs.triton; # Added 2023-05-06
  ts-node = throw "'ts-node' was removed because it is unmaintained, and since NodeJS 22.6.0+, experimental TypeScript support is built-in to NodeJS."; # Added 2025-11-07
  tsun = throw "'tsun' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  ttf2eot = throw "'ttf2eot' has been removed because it was unmaintained upstream"; # Added 2025-11-14
  typescript = pkgs.typescript; # Added 2023-06-21
  inherit (pkgs) typescript-language-server; # added 2024-02-27
  inherit (pkgs) uglify-js; # added 2024-06-15
  inherit (pkgs) undollar; # added 2024-06-29
  inherit (pkgs) ungit; # added 2023-08-20
  unified-language-server = throw "unified-language-server was removed as it is a library that should be imported within a Javascript project, not an end-user tool"; # added 2025-10-02
  inherit (pkgs) uppy-companion; # Added 2025-11-01
  inherit (pkgs) vega-lite; # Added 2025-11-04
  inherit (pkgs) vim-language-server; # added 2024-06-25
  vls = throw "vls has been deprecated by upstream as vetur is also deprecated. Upstream suggests migrating to Volar for Vue LSP tooling instead."; # added 2024-12-09
  inherit (pkgs) vsc-leetcode-cli; # Added 2023-08-30
  vscode-css-languageserver-bin = throw "vscode-css-languageserver-bin has been removed since the upstream repository is archived; consider using vscode-langservers-extracted instead."; # added 2024-06-26
  vscode-html-languageserver-bin = throw "vscode-html-languageserver-bin has been removed since the upstream repository is archived; consider using vscode-langservers-extracted instead."; # added 2024-06-26
  inherit (pkgs) vscode-json-languageserver; # added 2025-06-19
  vscode-json-languageserver-bin = throw "vscode-json-languageserver-bin has been removed since the upstream repository is archived; consider using vscode-langservers-extracted instead."; # added 2024-06-26
  vscode-langservers-extracted = pkgs.vscode-langservers-extracted; # Added 2023-05-27
  vue-language-server = self.vls; # added 2023-08-20
  vue-cli = throw "vue-cli has been removed since upstream no longer recommends using it; consider using create-vue and the new Vite-based tooling instead."; # added 2024-07-12
  inherit (pkgs) web-ext; # added 2023-08-20
  webpack = throw "'webpack' has been removed because it is a library that should be imported within a Javascript project, not an end-user tool."; # Added 2025-11-04
  inherit (pkgs) webpack-cli; # added 2024-12-03
  webpack-dev-server = throw "webpack-dev-server has been removed. You should install it in your JS project instead."; # added 2024-12-05
  webtorrent-cli = throw "webtorrent-cli has been removed because it was broken"; # added 2025-03-12
  inherit (pkgs) wrangler; # added 2024-07-01
  wring = throw "'wring' has been removed since it has been abandoned upstream"; # Added 2025-11-07
  inherit (pkgs) write-good; # added 2023-08-20
  inherit (pkgs) yalc; # added 2024-06-29
  inherit (pkgs) yaml-language-server; # added 2023-09-05
  inherit (pkgs) yarn; # added 2024-08-13
  inherit (pkgs) yo; # added 2023-08-20
  zx = pkgs.zx; # added 2023-08-01
}
