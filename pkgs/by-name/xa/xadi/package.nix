{
  lib,
  buildDubPackage,
  fetchFromGitHub,
  stdenv,
}:

buildDubPackage (finalAttrs: {
  pname = "xadi";
  version = "0-unstable-2025-06-07";

  src = fetchFromGitHub {
    owner = "xtool-org";
    repo = "xadi";
    rev = "61c02708c9cb046100f500878863fd2122b0d7e3";
    hash = "sha256-mKHZE5Al2RK0kDLq3gDzHp1+GmqMFo4R8SItrmY5tcE=";
  };

  dubLock = ./dub-lock.json;

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/lib bin/libxadi${stdenv.hostPlatform.extensions.sharedLibrary}
    runHook postInstall
  '';

  meta = {
    description = "CoreADI wrapper based on libprovision";
    homepage = "https://github.com/xtool-org/xadi";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ anish ];
  };
})
