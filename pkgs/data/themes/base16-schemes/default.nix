{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "base16-schemes";
  version = "unstable-2024-06-21";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "ef9a4c3c384624694608adebf0993d7a3bed3cf2";
    sha256 = "sha256-9i9IjZcjvinb/214x5YShUDBZBC2189HYs26uGy/Hck=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/
    install base16/*.yaml $out/share/themes/

    runHook postInstall
  '';

  meta = with lib; {
    description = "All the color schemes for use in base16 packages";
    homepage = finalAttrs.src.meta.homepage;
    maintainers = [ maintainers.DamienCassou ];
    license = licenses.mit;
  };
})
