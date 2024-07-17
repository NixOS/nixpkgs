{
  lib,
  stdenvNoCC,
  perl,
  installShellFiles,
  fetchFromBitbucket,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "when";
  version = "1.1.45";

  src = fetchFromBitbucket {
    repo = "when";
    owner = "ben-crowell";
    rev = finalAttrs.version;
    hash = "sha256-+ggYjY6/aTUrdvREn0TTQ4Pu/VR4QTjflDaicRXuOMs=";
  };

  buildInputs = [ perl ];

  nativeBuildInputs = [ installShellFiles ];

  postBuild = ''
    pod2man $src/when when.1
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 when $out/bin/when
    installManPage when.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "An extremely simple personal calendar program";
    homepage = "https://www.lightandmatter.com/when/when.html";
    license = licenses.gpl2Only;
    mainProgram = "when";
    maintainers = with maintainers; [ vonixxx ];
    platforms = platforms.all;
  };
})
