{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "ouch.yazi";
  version = "0-unstable-2025-03-29";

  src = fetchFromGitHub {
    owner = "ndtoan96";
    repo = "ouch.yazi";
    rev = "558188d2479d73cafb7ad8fb1bee12b2b59fb607";
    hash = "sha256-7X8uAiJ8vBXYBXOgyKhVVikOnTBGrdCcXOJemjQNolI=";
  };

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  meta = {
    description = "A Yazi plugin to preview archives.";
    homepage = "https://github.com/ndtoan96/ouch.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
