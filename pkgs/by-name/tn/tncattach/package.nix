{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tncattach";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "tncattach";
    rev = finalAttrs.version;
    hash = "sha256-s1uvUq9Y3/58wh3azcCu3KDxHQ1FHxMFX+rdjR9p6lg=";
  };

  nativeBuildInputs = [ installShellFiles ];

  makeFlags = [ "compiler=$(CC)" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 tncattach -t $out/bin
    installManPage tncattach.8
    runHook postInstall
  '';

  meta = {
    description = "Attach KISS TNC devices as network interfaces";
    homepage = "https://github.com/markqvist/tncattach";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarcasticadmin ];
    platforms = lib.platforms.linux;
    mainProgram = "tncattach";
  };
})
