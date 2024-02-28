{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "base16-schemes";
  version = "unstable-2024-01-14";

  src = fetchFromGitHub {
    owner = "tinted-theming";
    repo = "schemes";
    rev = "395074124283df993571f2abb9c713f413b76e6e";
    sha256 = "sha256-9LmwYbtTxNFiP+osqRUbOXghJXpYvyvAwBwW80JMO7s=";
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
