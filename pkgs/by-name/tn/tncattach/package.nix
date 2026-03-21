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
    sha256 = "0n7ad4gqvpgabw2i67s51lfz386wmv0cvnhxq9ygxpsqmx9aynxk";
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
