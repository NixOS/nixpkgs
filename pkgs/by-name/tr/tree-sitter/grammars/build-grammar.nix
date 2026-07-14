{
  stdenv,
  nodejs,
  tree-sitter,
  jq,
  lib,
}:

{
  language,
  version,
  src,
  meta ? { },
  generate ? false,
  excludeBrokenTreeSitterJson ? false,
  ...
}@args:

let
  isWasi = stdenv.hostPlatform.isWasi;
  parserOutput = if isWasi then "parser.wasm" else "parser";
  exportSymbol = "tree_sitter_${lib.replaceStrings [ "-" ] [ "_" ] language}";
in
stdenv.mkDerivation (
  {
    pname = "tree-sitter-${language}";

    inherit version src;

    __structuredAttrs = true;

    nativeBuildInputs = [
      jq
    ]
    ++ lib.optionals generate [
      nodejs
      tree-sitter
    ];

    CFLAGS = [
      "-Isrc"
      # Match upstream `tree-sitter build --wasm`
      (if isWasi then "-Os" else "-O2")
    ]
    ++ lib.optionals isWasi [
      "-fvisibility=hidden"
    ];
    CXXFLAGS = [
      "-Isrc"
      (if isWasi then "-Os" else "-O2")
    ]
    ++ lib.optionals isWasi [
      "-fvisibility=hidden"
    ];

    stripDebugList = [ "parser" ];

    # Not all tree-sitter.json files follow the schema. If they're invalid,
    # remove them. Note: these tree-sitter.json files are not validated here,
    # but are validated in python3Packages.tree-sitter-grammars.
    postPatch = lib.optionalString excludeBrokenTreeSitterJson ''
      rm tree-sitter.json
    '';

    # Tree-sitter grammar packages contain a `tree-sitter.json` file at their
    # root. This provides package metadata that can be used to infer build
    # details.
    #
    # See https://tree-sitter.github.io/tree-sitter/cli/init.html for spec.
    configurePhase = ''
      runHook preConfigure
      if [[ -e tree-sitter.json ]]; then
        # Check nix package version matches grammar source
        NIX_VERSION=${lib.head (lib.splitString "+" version)}
        SRC_VERSION=$(jq -r '.metadata.version' tree-sitter.json)
        if [[ "$NIX_VERSION" != "$SRC_VERSION" ]]; then
          nixErrorLog "grammar version ($NIX_VERSION) differs from source ($SRC_VERSION)"
        fi

        # Check language name matches source
        GRAMMAR=$(jq -c 'first(.grammars[] | select(.name == env.language))' tree-sitter.json)
        if [[ -z "$GRAMMAR" ]]; then
          GRAMMAR=$(jq -c 'first(.grammars[]) // {}' tree-sitter.json)
          NAME=$(jq -r '.name' <<< "$GRAMMAR")
          SRC_LANGS=$(jq -r '[.grammars[].name] | join(", ")' tree-sitter.json)
          nixErrorLog "grammar name ($language) not found in source grammars ($SRC_LANGS), continuing with $NAME"
        fi

        # Move to the appropriate working directory for build
        cd -- $(jq -r '.path // "."' <<< $GRAMMAR)
      else
        # Older grammars may not contain this file. The tree-sitter CLI provides
        # a warning rather than fail unless ABI > 14. Mirror that behaviour
        # while older grammars age out.
        nixWarnLog "grammar source is missing tree-sitter.json"
      fi
      runHook postConfigure
    '';

    # Optionally regenerate the parser source from the defined grammar. In most
    # cases this should not be required as convention is to have this checked
    # in to the source repo.
    preBuild = lib.optionalString generate ''
      tree-sitter generate
    '';

    buildPhase =
      if isWasi then
        ''
          runHook preBuild
          if [[ -e src/scanner.cc || -e src/scanner.cpp ]]; then
            nixErrorLog "tree-sitter wasm grammars only support C external scanners"
            exit 1
          fi
          if [[ -e src/scanner.c ]]; then
            $CC -fPIC -c src/scanner.c -o scanner.o $CFLAGS
          fi
          $CC -fPIC -c src/parser.c -o parser.o $CFLAGS
          rm -rf parser.wasm
          $CC -shared -o parser.wasm *.o \
            -Wl,--export=${exportSymbol} \
            -Wl,--allow-undefined \
            -Wl,--no-entry \
            -nostdlib
          runHook postBuild
        ''
      else
        ''
          runHook preBuild
          if [[ -e src/scanner.cc ]]; then
            $CXX -fPIC -c src/scanner.cc -o scanner.o $CXXFLAGS
          elif [[ -e src/scanner.c ]]; then
            $CC -fPIC -c src/scanner.c -o scanner.o $CFLAGS
          fi
          $CC -fPIC -c src/parser.c -o parser.o $CFLAGS
          rm -rf parser
          $CXX -shared -o parser *.o
          runHook postBuild
        '';

    installPhase = ''
      runHook preInstall
      mkdir $out
      mv ${parserOutput} $out/
      if [[ -f tree-sitter.json ]]; then
        cp tree-sitter.json $out/
      fi
      if [[ -d queries ]]; then
        cp -r queries $out
      fi
      runHook postInstall
    '';

    # Merge default meta attrs with any explicitly defined on the source.
    meta = {
      description = "Tree-sitter grammar for ${language}";
    }
    // (lib.optionalAttrs (src ? meta.homepage) {
      homepage = src.meta.homepage;
    })
    // meta;
  }
  # FIXME: neovim and nvim-treesitter currently rely on passing location rather
  # than a src attribute with a correctly positioned root (e.g. for grammars in
  # monorepos). Use this if present for now.
  // (lib.optionalAttrs (args ? location && args.location != null) {
    setSourceRoot = "sourceRoot=$(echo */${args.location})";
  })
  // removeAttrs args [
    "generate"
    "excludeBrokenTreeSitterJson"
    "meta"
  ]
)
