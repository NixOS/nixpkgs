/*
  This file provides the `tectonic-unwrapped` package. On the other hand,
  the `tectonic` package is defined in `../tectonic/package.nix`, by wrapping
  - [`tectonic-unwrapped`](./package.nix) i.e. this package, and
  - [`biber-for-tectonic`](../../bi/biber-for-tectonic/package.nix),
    which provides a compatible version of `biber`.
*/

{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,

  # nativeBuildInputs
  pkg-config,
  installShellFiles,

  # buildInputs
  fontconfig,
  harfbuzzFull,
  openssl,
  icu,

  # passthru.tests
  tectonic,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tectonic";
  version = "0.16.9";

  src = fetchFromGitHub {
    owner = "tectonic-typesetting";
    repo = "tectonic";
    rev = "tectonic@${finalAttrs.version}";
    sha256 = "sha256-5yphhmrrfgFwQ952eWpToyGfIJVJfV6y5w0BgznSOe0=";
  };

  cargoHash = "sha256-22Hy51zCzY2DRytcYHgwkI9+e/g52o1jy4eosvEm3KY=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildFeatures = [ "external-harfbuzz" ];

  buildInputs = [
    icu
    fontconfig
    harfbuzzFull
    openssl
  ];

  # By default, tectonic looks up the latest bundle by opening this URL:
  #
  #   https://relay.fullyjustified.net/default_bundle_v${FORMAT_VERSION}.tar
  #
  # Where FORMAT_VERSION is defined here:
  #
  #   https://github.com/tectonic-typesetting/tectonic/blob/master/crates/engine_xetex/xetex/xetex_bindings.h
  #
  # When we updated the package, this URL redirects to the following:
  #
  #   https://data1.fullyjustified.net/tlextras-2022.0r0.tar
  #
  # The environment variable set below, sets the URL that will be used during
  # runtime by default. We chose to hard-code a URL to a specific version of
  # the web bundle, so that upstream won't update the `default_bundle` without
  # us noticing, and break compatibility with our biber-for-tectonic package.
  #
  # This is in principle the right thing to do, ever since the 0.16.0 release.
  # As opposed to what we had with version 0.15.0, we choose to not hard-code a
  # --web-bundle (or --bundle) argument in the wrapper of the
  # `tectonic-wrapped` package, as it is not compatible with nextonic, and
  # `tectonic -X` commands of versions 0.16.0+ -- These commands require the
  # `--bundle` argument to appear after the subcommand.
  #
  # Lastly, we might in the future need to update the bundle URL below if
  # upstream will upload a new bundle. However, upstream hasn't updated a new
  # bundle for a long time, see:
  #
  #   https://github.com/tectonic-typesetting/tectonic/issues/1269
  #
  env.TECTONIC_BUNDLE_LOCKED = "https://data1.fullyjustified.net/tlextras-2022.0r0.tar";

  postInstall = ''
    # Makes it possible to automatically use the V2 CLI API
    ln -s $out/bin/tectonic $out/bin/nextonic
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace dist/appimage/tectonic.desktop \
      --replace-fail Exec=tectonic Exec=$out/bin/tectonic
    install -Dm644 dist/appimage/tectonic.desktop -t $out/share/applications/
    install -Dm644 dist/appimage/tectonic.svg -t $out/share/icons/hicolor/scalable/apps/
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd nextonic \
      --bash <($out/bin/nextonic show shell-completions bash) \
      --zsh <($out/bin/nextonic show shell-completions zsh) \
      --fish <($out/bin/nextonic show shell-completions fish)
  '';

  checkFlags = [
    # Test fails due to tectonic bundle missing and can't be downloaded in the
    # sandbox
    "--skip=tests::no_segfault_after_failed_compilation"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Test Panics only on Darwin, see:
    # https://github.com/tectonic-typesetting/tectonic/issues/1352
    "--skip=v2_watch_succeeds"
  ];
  doCheck = true;

  passthru = {
    inherit (tectonic.passthru) tests;
  };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive";
    homepage = "https://tectonic-typesetting.github.io/";
    changelog = "https://github.com/tectonic-typesetting/tectonic/blob/tectonic@${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    mainProgram = "tectonic";
    maintainers = with lib.maintainers; [
      lluchs
      doronbehar
      bryango
    ];
  };
})
