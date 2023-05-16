<<<<<<< HEAD
# Use this file to add `meta.mainProgram` to packages in `nodePackages`.
=======
# Use this file to add `meta.mainProgram` to packages in `nodePackages`, that don't provide an
# executable that matches that packages name, so that they'll work with `nix run`.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
{
  # Packages that provide multiple executables where one is clearly the `mainProgram`.
  "@antfu/ni" = "ni";
  "@electron-forge/cli" = "electron-forge";
  "@microsoft/rush" = "rush";
<<<<<<< HEAD
  "@webassemblyjs/cli-1.11.1" = "wasm2wast";
  "@withgraphite/graphite-cli" = "gt";

  # Packages that provide a single executable.
  "@angular/cli" = "ng";
  "@antora/cli" = "antora";
  "@astrojs/language-server" = "astro-ls";
  "@babel/cli" = "babel";
  "@commitlint/cli" = "commitlint";
  "@forge/cli" = "forge";
  "@gitbeaker/cli" = "gitbeaker";
=======
  "@squoosh/cli" = "squoosh-cli";
  "@webassemblyjs/cli-1.11.1" = "wasm2wast";
  coffee-script = "coffee";
  typescript = "tsc";
  vue-cli = "vue";
  "@withgraphite/graphite-cli" = "gt";

  # Packages that provide a single executable whose name differs from the package's `name`.
  "@angular/cli" = "ng";
  "@antora/cli" = "antora";
  "@astrojs/language-server" = "astro-ls";
  "@bitwarden/cli" = "bw";
  "@commitlint/cli" = "commitlint";
  "@forge/cli" = "forge";
  "@gitbeaker/cli" = "gitbeaker";
  "@medable/mdctl-cli" = "mdctl";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  "@mermaid-js/mermaid-cli" = "mmdc";
  "@nerdwallet/shepherd" = "shepherd";
  "@prisma/language-server" = "prisma-language-server";
  "@tailwindcss/language-server" = "tailwindcss-language-server";
  "@uppy/companion" = "companion";
  "@vue/cli" = "vue";
  "@webassemblyjs/repl-1.11.1" = "wasm";
  "@webassemblyjs/wasm-strip" = "wasm-strip";
  "@webassemblyjs/wasm-text-gen-1.11.1" = "wasmgen";
  "@webassemblyjs/wast-refmt-1.11.1" = "wast-refmt";
  aws-cdk = "cdk";
<<<<<<< HEAD
  cdk8s-cli = "cdk8s";
  cdktf-cli = "cdktf";
  clipboard-cli = "clipboard";
  conventional-changelog-cli = "conventional-changelog";
  cpy-cli = "cpy";
  diff2html-cli = "diff2html";
  fast-cli = "fast";
  fauna-shell = "fauna";
=======
  balanceofsatoshis = "bos";
  carbon-now-cli = "carbon-now";
  cdk8s-cli = "cdk8s";
  cdktf-cli = "cdktf";
  clean-css-cli = "cleancss";
  clipboard-cli = "clipboard";
  clubhouse-cli = "club";
  conventional-changelog-cli = "conventional-changelog";
  cpy-cli = "cpy";
  diff2html-cli = "diff2html";
  dockerfile-language-server-nodejs = "docker-langserver";
  fast-cli = "fast";
  fauna-shell = "fauna";
  firebase-tools = "firebase";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  fkill-cli = "fkill";
  fleek-cli = "fleek";
  git-run = "gr";
  gitmoji-cli = "gitmoji";
  graphql-cli = "graphql";
  graphql-language-service-cli = "graphql-lsp";
  grunt-cli = "grunt";
  gulp-cli = "gulp";
  kaput-cli = "kaput";
<<<<<<< HEAD
  less = "lessc";
  localtunnel = "lt";
  lua-fmt = "luafmt";
  neovim = "neovim-node-host";
  parsoid = "parse.js";
  poor-mans-t-sql-formatter-cli = "sqlformat";
  postcss-cli = "postcss";
  prettier = "prettier";
  purescript-psa = "psa";
  purs-tidy = "purs-tidy";
  react-native-cli = "react-native";
  react-tools = "jsx";
  remod-cli = "remod";
  svelte-language-server = "svelteserver";
  teck-programmer = "teck-firmware-upgrade";
  typescript-language-server = "typescript-language-server";
=======
  leetcode-cli = "leetcode";
  less = "lessc";
  localtunnel = "lt";
  lua-fmt = "luafmt";
  markdownlint-cli = "markdownlint";
  near-cli = "near";
  neovim = "neovim-node-host";
  parcel-bundler = "parcel";
  parsoid = "parse.js";
  poor-mans-t-sql-formatter-cli = "sqlformat";
  postcss-cli = "postcss";
  purescript-psa = "psa";
  react-native-cli = "react-native";
  react-tools = "jsx";
  remod-cli = "remod";
  s3http = "s3http.js";
  svelte-language-server = "svelteserver";
  teck-programmer = "teck-firmware-upgrade";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  uglify-js = "uglifyjs";
  undollar = "$";
  vsc-leetcode-cli = "leetcode";
  vscode-css-languageserver-bin = "css-languageserver";
  vscode-html-languageserver-bin = "html-languageserver";
  vscode-json-languageserver-bin = "json-languageserver";
<<<<<<< HEAD
=======
  vue-language-server = "vls";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  webtorrent-cli = "webtorrent";
  "@zwave-js/server" = "zwave-server";
}
