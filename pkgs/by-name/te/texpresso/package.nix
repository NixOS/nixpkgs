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
  version = "0.1";

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "texpresso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d+wNQIysn3hdTQnHN9MJbFOIhJQ0ml6PoeuwsryntTI=";
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
      nix-update texpresso
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
