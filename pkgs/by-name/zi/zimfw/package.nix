{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zimfw";
  version = "1.20.0";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "zimfw";
    tag = "v${finalAttrs.version}";
    ## zim only needs this one file to be installed.
    sparseCheckout = [ "zimfw.zsh" ];
    hash = "sha256-fwpmeFDQRsTnWSoa9N3C+G/LDBCmDtbl+ckcyndMr7c=";
  };
  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r $src/zimfw.zsh $out/

    runHook postInstall
  '';

  meta = {
    description = "Zsh configuration framework with blazing speed and modular extensions";
    homepage = "https://zimfw.sh";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.joedevivo ];
    platforms = lib.platforms.all;
  };
})
