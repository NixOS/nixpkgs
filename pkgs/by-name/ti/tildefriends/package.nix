{
  lib,
  stdenv,
  fetchgit,
  openssl,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tildefriends";
  version = "0.2026.7";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchgit {
    url = "https://dev.tildefriends.net/cory/tildefriends.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VK1hSnhw1v8kX6zxt4zrknS2MA1Qphtf71CC1IL75EQ=";
  };

  nativeBuildInputs = [
    which
  ];
  
  buildInputs = [
    openssl
  ];

  buildFlags = [ "release" ];

  installPhase = ''
    runHook preInstall
    
    install -D out/release/tildefriends $out/bin/tildefriends
    
    runHook postInstall
  '';

  doCheck = false;

  meta = {
    homepage = "https://tildefriends.net";
    description = "A Secure Scuttlebutt decentralized social network client";
    mainProgram = "tildefriends";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GearKite ];
    platforms = lib.platforms.all;
  };
})
