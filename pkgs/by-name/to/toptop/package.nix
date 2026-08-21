{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  dust,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "toptop";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "DazorPlasma";
    repo = "toptop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DZEw5o9+nGXMM2xepBOQ9SUTMjiknja9UwGbeIuFdKM=";
  };

  cargoHash = "sha256-bXQ6/jBUIv36SmV5c4Vj97LpL+kYi6oOpZL7KsGbngs=";

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/toptop \
      --prefix PATH : ${lib.makeBinPath [ dust ]}
  '';

  meta = {
    description = "A fast, lightweight, and modern terminal system monitor";
    homepage = "https://github.com/DazorPlasma/toptop";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dazor ];
    mainProgram = "toptop";
    platforms = lib.platforms.linux;
  };
})
