{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tocaia";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "manipuladordedados";
    repo = "tocaia";
    tag = finalAttrs.version;
    hash = "sha256-Np+Awn5KGoAbeoUEkcAeVwnNCqI2Iy+19Zj1RkNfgXU=";
  };

  meta = {
  meta = with lib; {
    homepage = "https://github.com/manipuladordedados/tocaia";
    changelog = "https://github.com/manipuladordedados/tocaia/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ manipuladordedados ];
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ manipuladordedados ];
    platforms = platforms.unix;
  };
}
