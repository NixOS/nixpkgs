{
  lib,
  _experimental-update-script-combinators,
  fetchFromGitHub,
  fetchSwiftPMDeps,
  gitUpdater,
  libarchive,
  pkg-config,
  stdenv,
  swift,
  swiftpm,
  swiftpmDepsUpdater,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swiftly";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "swiftlang";
    repo = "swiftly";
    tag = finalAttrs.version;
    hash = "sha256-VFgmgo69Q4Y8Je0SMdB3jKGt9lNoVYAaUhSuK3RUkFE=";
  };

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-1KfyrQXE1HaO9WsuskzgiiEZxM/oelp40Jwzr8xJEL4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    swift
    swiftpm
  ]
  # Required for libarchive.
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = [
    zlib
  ]
  # Swiftly requires libarchive on Linux but not Darwin.
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libarchive ];

  doCheck = false; # Too many impure tests that fail. Need a mechanism to disable just those tests.

  __structuredAttrs = true;

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (gitUpdater { })
    (swiftpmDepsUpdater { })
  ];

  meta = {
    description = "Swift toolchain installer and manager";
    mainProgram = "swiftly";
    homepage = "https://github.com/swiftlang/swiftly";
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    license = lib.licenses.asl20;
    teams = [ lib.teams.swift ];
  };
})
