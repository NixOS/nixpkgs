{ lib
, rustPlatform
, fetchFromGitHub
, curl
, pkg-config
, protobuf
, xcbuild
, fontconfig
, freetype
, libgit2
, openssl
, sqlite
, zlib
, zstd
, alsa-lib
, libxkbcommon
, wayland
, xorg
, stdenv
, darwin
, vulkan-loader
}:

rustPlatform.buildRustPackage rec {
  pname = "zed";
  version = "0.128.3";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "zed";
    rev = "refs/tags/v${version}";
    hash = "sha256-a4bZ53srS0y7oAAbe4F+lSm7K7e2J2uhM3RPJQ5NVQI=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "alacritty_terminal-0.22.1-dev" = "sha256-mWdZsKx7cNoyEdXyhOXsbS0L14H2uHYGWGBaRjNXJic=";
      "async-pipe-0.1.3" = "sha256-g120X88HGT8P6GNCrzpS5SutALx5H+45Sf4iSSxzctE=";
      "blade-graphics-0.3.0" = "sha256-0TmunFnq9MBxm4TrAkI0PxB58qJEf7oWLWhHq5cVsQ8=";
      "bromberg_sl2-0.6.0" = "sha256-+bwdnk3EgYEAxQSP4KpEPicCfO+r2er1DRZjvfF4jSM=";
      "font-kit-0.11.0" = "sha256-+4zMzjFyMS60HfLMEXGfXqKn6P+pOngLA45udV09DM8=";
      "lsp-types-0.94.1" = "sha256-kplgPsafrgZFMI1D9pQCwmg+FKMn5HNWLbcgdXHUFVU=";
      "nvim-rs-0.6.0-pre" = "sha256-bdWWuCsBv01mnPA5e5zRpq48BgOqaqIcAu+b7y1NnM8=";
      "pathfinder_simd-0.5.3" = "sha256-bakBcAQZJdHQPXybe0zoMzE49aOHENQY7/ZWZUMt+pM=";
      "taffy-0.3.11" = "sha256-0hXOEj6IjSW8e1t+rvxBFX6V9XRum3QO2Des1XlHJEw=";
      "tree-sitter-0.20.100" = "sha256-OQp3BMUgfLYlc9SdN+DNKN4g/CR63DibztbU3DTkNpw=";
      "tree-sitter-astro-0.0.1" = "sha256-FNnkti4Ypw4RGIrIL9GtgjlYFMmOWZ2f8uQg/h3xesA=";
      "tree-sitter-bash-0.20.4" = "sha256-VP7rJfE/k8KV1XN1w5f0YKjCnDMYU1go/up0zj1mabM=";
      "tree-sitter-c-sharp-0.20.0" = "sha256-DlnGIky33CuRKkVVS+tOTBLVOVzASXqdaUrZawh6LZc=";
      "tree-sitter-clojure-0.0.9" = "sha256-H0OEnsoJxcDqlJ32ac7KCS2stT02XKrZ/v4mGMoN2EI=";
      "tree-sitter-cpp-0.20.0" = "sha256-2QYEFkpwcRmh2kf4qEAL2a5lGSa316CetOhF73e7rEM=";
      "tree-sitter-css-0.19.0" = "sha256-5Qti/bFac2A1PJxqZEOuSLK3GGKYwPDKAp3OOassBxU=";
      "tree-sitter-dart-0.0.1" = "sha256-FE6zXy0lAUWWayrM3urZFnQaEYBcnmaVANcUUnvw1q4=";
      "tree-sitter-dockerfile-0.1.0" = "sha256-uCKzTTbJL9Ans3lCQbt2zApF+ERLbbu5D1WcyWJ6Gf4=";
      "tree-sitter-elixir-0.1.0" = "sha256-hBHqQ3eBjknRPJjP+lQJU6NPFhUMtiv4FbKsTw28Bog=";
      "tree-sitter-elm-5.6.4" = "sha256-0LpuyebOB5ew9fULBcaw8aUbF7HM5sXQpv+Jroz4tXg=";
      "tree-sitter-gleam-0.34.0" = "sha256-VtuGsa8jKndxlyJKy9UHfZXvAgr63Q0iwceXKfEUAYE=";
      "tree-sitter-glsl-0.1.4" = "sha256-TRuiT3ndCeDCsCFokAN8cosNKccB0NjWVRiBJuBJXZw=";
      "tree-sitter-go-0.19.1" = "sha256-5+L5QqVjZyeh+sKfxKZWrjIBFE5xM9KZlHcLiHzJCIA=";
      "tree-sitter-gomod-1.0.2" = "sha256-OPtqXe6OMC9c5dgFH8Msj+6DU01LvLKVbCzGLj0PnLI=";
      "tree-sitter-gowork-0.0.1" = "sha256-lM4L4Ap/c8uCr4xUw9+l/vaGb3FxxnuZI0+xKYFDPVg=";
      "tree-sitter-haskell-0.14.0" = "sha256-QIGLxc2BPGqglvpInjmmP/9gUoPEX21WrxsoGOKP03o=";
      "tree-sitter-hcl-0.0.1" = "sha256-saVKSYUJY7OuIuNm9EpQnhFO/vQGKxCXuv3EKYOJzfs=";
      "tree-sitter-heex-0.0.1" = "sha256-6LREyZhdTDt3YHVRPDyqCaDXqcsPlHOoMFDb2B3+3xM=";
      "tree-sitter-jsdoc-0.20.0" = "sha256-fKscFhgZ/BQnYnE5EwurFZgiE//O0WagRIHVtDyes/Y=";
      "tree-sitter-json-0.20.0" = "sha256-fZNftzNavJQPQE4S1VLhRyGQRoJgbWA5xTPa8ZI5UX4=";
      "tree-sitter-markdown-0.0.1" = "sha256-F8VVd7yYa4nCrj/HEC13BTC7lkV3XSb2Z3BNi/VfSbs=";
      "tree-sitter-nix-0.0.1" = "sha256-+o+f1TlhcrcCB3TNw1RyCjVZ+37e11nL+GWBPo0Mxxg=";
      "tree-sitter-nu-0.0.1" = "sha256-V6EZfba5e0NdOG4n3DNI25luNXfcCN3+/vNYuz9llUk=";
      "tree-sitter-ocaml-0.20.4" = "sha256-ycmjIKfrsVSVHmPP3HCxfk5wcBIF/JFH8OnU8mY1Cc8=";
      "tree-sitter-prisma-io-1.4.0" = "sha256-MOqkM7DCQl1L8Jn9nyw89EoAr0ez4+d39HeKy2cb66c=";
      "tree-sitter-proto-0.0.2" = "sha256-W0diP2ByAXYrc7Mu/sbqST6lgVIyHeSBmH7/y/X3NhU=";
      "tree-sitter-purescript-0.1.0" = "sha256-vnOeOeo3LjZbfj0C061oopjDpCOGv0TVg5nXuPcH29w=";
      "tree-sitter-racket-0.0.1" = "sha256-ie64no94TtAWsSYaBXmic4oyRAA01fMl97+JWcFU1E8=";
      "tree-sitter-scheme-0.2.0" = "sha256-K3+zmykjq2DpCnk17Ko9LOyGQTBZb1/dgVXIVynCYd4=";
      "tree-sitter-svelte-0.10.2" = "sha256-FZuzbTOP9LokPb77DSUwIXCFvMmDQPyyLKt7vNtEuAY=";
      "tree-sitter-toml-0.5.1" = "sha256-5nLNBxFeOGE+gzbwpcrTVnuL1jLUA0ZLBVw2QrOLsDQ=";
      "tree-sitter-typescript-0.20.2" = "sha256-cpOAtfvlffS57BrXaoa2xa9NUYw0AsHxVI8PrcpgZCQ=";
      "tree-sitter-vue-0.0.1" = "sha256-8v2e03A/Uj6zCJTH4j6TPwDQcNFeze1jepMADT6UVis=";
      "tree-sitter-yaml-0.0.1" = "sha256-S59jLlipBI2kwFuZDMmpv0TOZpGyXpbAizN3yC6wJ5I=";
      "tree-sitter-zig-0.0.1" = "sha256-a3W7eBUN4V3HD3YPr1+3tpuWQfIQy1Wu8qxCQx0hEnI=";
    };
  };

  nativeBuildInputs = [
    curl
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ] ++ lib.optionals stdenv.isDarwin [
    xcbuild.xcrun
  ];

  buildInputs = [
    curl
    fontconfig
    freetype
    libgit2
    openssl
    sqlite
    zlib
    zstd
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    libxkbcommon
    wayland
    xorg.libxcb
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AppKit
    CoreAudio
    CoreFoundation
    CoreGraphics
    CoreMedia
    CoreServices
    CoreText
    Foundation
    IOKit
    Metal
    Security
    SystemConfiguration
    VideoToolbox
  ]);

  buildFeatures = [
    "gpui/runtime_shaders"
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf --add-rpath ${vulkan-loader}/lib $out/bin/*
  '';

  # Fail with "unimplemented error"
  checkFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "--skip=test_base_keymap"
    "--skip=test_bundled_settings_and_themes"
    "--skip=test_disabled_keymap_binding"
    "--skip=test_navigation"
    "--skip=test_new_empty_workspace"
    "--skip=test_open_and_save_new_file"
    "--skip=test_open_entry"
    "--skip=test_opening_excluded_paths"
    "--skip=test_open_paths"
    "--skip=test_open_paths_action"
    "--skip=test_pane_actions"
    "--skip=test_reopening_closed_items"
    "--skip=test_save_conflicting_item"
    "--skip=test_setting_language_when_saving_as_single_file_worktree"
    "--skip=test_window_edit_state"
  ];

  meta = with lib; {
    description = "A high-performance, multiplayer code editor from the creators of Atom and Tree-sitter";
    homepage = "https://zed.dev";
    changelog = "https://github.com/zed-industries/zed/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ GaetanLepage niklaskorz ];
    mainProgram = "zed";
    platforms = platforms.all;
  };
}
