{
  stdenv,
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wild";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "davidlattimore";
    repo = "wild";
    tag = finalAttrs.version;
    hash = "sha256-tVGvSd4aege3xz/CrEl98AwuEJlsM3nVVG0urTSajFQ=";
  };

  cargoHash = "sha256-dXIYJfjz6okiLJuX4ZHu0Ft2/9XDjCrvvl/eqeuvBkU=";

  # Integration tests need lld
  doCheck = false;

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optionals stdenv.hostPlatform.isUnix [
    "fork"
  ];

  meta = {
    description = "Fast linker for Linux";
    homepage = "https://github.com/davidlattimore/wild";
    license = [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = [ lib.maintainers.theoparis ];
    platforms = lib.platforms.linux;
  };
})
