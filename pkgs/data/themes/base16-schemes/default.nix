{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "base16-schemes";
<<<<<<< HEAD
  version = "unstable-2023-05-02";
=======
  version = "unstable-2022-12-16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-schemes";
<<<<<<< HEAD
    rev = "9a4002f78dd1094c123169da243680b2fda3fe69";
    sha256 = "sha256-AngNF++RZQB0l4M8pRgcv66pAcIPY+cCwmUOd+RBJKA=";
=======
    rev = "cf6bc892a24af19e11383adedc6ce7901f133ea7";
    sha256 = "sha256-U9pfie3qABp5sTr3M9ga/jX8C807FeiXlmEZnC4ZM58=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
