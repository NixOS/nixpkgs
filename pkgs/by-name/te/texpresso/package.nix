{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  writeScript,
  mupdf,
  SDL2,
  re2c,
  freetype,
  jbig2dec,
  harfbuzz,
  openjpeg,
  gumbo,
  libjpeg,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "texpresso";
  version = "0-unstable-2025-01-29";

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "texpresso";
    rev = "c42a5912f501f180984840fa8adf9ffc09c5ac13";
    hash = "sha256-T/vou7OcGtNoodCrznmjBLxg6ZAFDCjhpYgNyZaf44g=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "CC=gcc" "CC=${stdenv.cc.targetPrefix}cc" \
      --replace-fail "LDCC=g++" "LDCC=${stdenv.cc.targetPrefix}c++"
  '';

  nativeBuildInputs = [
    makeWrapper
    mupdf
    SDL2
    re2c
    freetype
    jbig2dec
    harfbuzz
    openjpeg
    gumbo
    libjpeg
  ];

  buildFlags = [ "texpresso" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-Wno-error=implicit-function-declaration"
    ]
  );

  installPhase = ''
    runHook preInstall
    install -Dm0755 -t "$out/bin/" "build/texpresso"
    runHook postInstall
  '';

  # needs to have texpresso-tonic on its path
  postInstall = ''
    wrapProgram $out/bin/texpresso \
      --prefix PATH : ${lib.makeBinPath [ finalAttrs.finalPackage.passthru.tectonic ]}
  '';

  passthru = {
    tectonic = callPackage ./tectonic.nix { };
    updateScript = writeScript "update-texpresso" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq nix-update

      tectonic_version="$(curl -s "https://api.github.com/repos/let-def/texpresso/contents/tectonic" | jq -r '.sha')"
      nix-update --version=branch texpresso
      nix-update --version=branch=$tectonic_version texpresso.tectonic
    '';
  };

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Live rendering and error reporting for LaTeX";
    maintainers = with lib.maintainers; [ nickhu ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
