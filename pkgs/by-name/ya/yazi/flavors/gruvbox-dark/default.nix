{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "gruvbox-dark";
  version = "0-unstable-2025-12-10";
  src = fetchFromGitHub {
    owner = "bennyyip";
    repo = "gruvbox-dark.yazi";
    rev = "2c61c90e8725136760e5d12b7ebc4c24d602241b";
    hash = "sha256-qNxauqv8tRPztO17PGKl3ue6cSWGqIuEzYViaRXDVcQ=";
  };
  installPhase = ''
    runHook preInstall

    install -D $src/* -t $out

    runHook postInstall
  '';
  meta = {
    description = "Gruvbox Dark Flavor for Yazi";
    homepage = "https://github.com/bennyyip/gruvbox-dark.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ valyntyler ];
  };
}
