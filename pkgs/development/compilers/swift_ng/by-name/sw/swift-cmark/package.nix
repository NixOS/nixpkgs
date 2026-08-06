{
  lib,
  cmake,
  fetchFromGitHub,
  gitUpdater,
  ninja,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swift-cmark";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swift-cmark";
    tag = finalAttrs.version;
    hash = "sha256-0pyZ5yQRsbiKwz2XT8N6dMwCLcmM28qQOrxHcV6uH7g=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru.updateScript = gitUpdater { };

  __structuredAttrs = true;

  meta = {
    description = "CommonMark parsing and rendering library";
    homepage = "https://github.com/swiftlang/swift-cmark";
    platforms = lib.platforms.unix ++ lib.platforms.windows ++ lib.platforms.wasi;
    license = [
      lib.licenses.bsd2
      lib.licenses.mit
    ];
    teams = [ lib.teams.swift ];
  };
})
