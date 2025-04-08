{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "starship.yazi";
  version = "25.2.7-unstable-2025-02-23";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "starship.yazi";
    rev = "6c639b474aabb17f5fecce18a4c97bf90b016512";
    hash = "sha256-bhLUziCDnF4QDCyysRn7Az35RAy8ibZIVUzoPgyEO1A=";
  };

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  meta = {
    description = "Starship prompt plugin for yazi.";
    homepage = "https://github.com/Rolv-Apneseth/starship.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
