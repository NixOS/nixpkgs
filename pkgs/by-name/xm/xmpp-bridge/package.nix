{ lib
, fetchFromGitHub
, stdenv
, pkg-config
, libstrophe
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "xmpp-bridge";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "majewsky";
    repo = "xmpp-bridge";
    rev = "v${version}";
    hash = "sha256-JXhVi2AiV/PmWPfoQJl/N92GAZQ9UxReAiCkiDxgdFY=";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    libstrophe
  ];

  strictDeps  = true;

  # Makefile is hardcoded to install to /usr, install manually
  installPhase = ''
    runHook  preInstall

    install -D -m 0755 build/xmpp-bridge "$out/bin/xmpp-bridge"
    installManPage xmpp-bridge.1

    runHook postInstall
  '';

  meta = {
    description = "Connect command-line programs to XMPP";
    homepage = "https://github.com/majewsky/xmpp-bridge";
    license = lib.licenses.gpl3Plus;
    mainProgram = "xmpp-bridge";
    maintainers = with lib.maintainers; [ gigahawk ];
    platforms = lib.platforms.unix;
  };
}
