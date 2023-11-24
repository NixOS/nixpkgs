{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "base16-schemes";
  version = "unstable-2023-05-02";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-schemes";
    rev = "9a4002f78dd1094c123169da243680b2fda3fe69";
    sha256 = "sha256-AngNF++RZQB0l4M8pRgcv66pAcIPY+cCwmUOd+RBJKA=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/
    install *.yaml $out/share/themes/

    runHook postInstall
  '';

  meta = with lib; {
    description = "All the color schemes for use in base16 packages";
    homepage = finalAttrs.src.meta.homepage;
    maintainers = [ maintainers.DamienCassou ];
    license = licenses.mit;
  };
})
