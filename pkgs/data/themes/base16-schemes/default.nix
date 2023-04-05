{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "base16-schemes";
  version = "unstable-2022-12-16";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-schemes";
    rev = "cf6bc892a24af19e11383adedc6ce7901f133ea7";
    sha256 = "sha256-U9pfie3qABp5sTr3M9ga/jX8C807FeiXlmEZnC4ZM58=";
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
