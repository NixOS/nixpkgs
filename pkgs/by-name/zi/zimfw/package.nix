{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "zimfw";
  version = "1.19.1";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "zimfw";
    tag = "v${version}";
    ## zim only needs this one file to be installed.
    sparseCheckout = [ "zimfw.zsh" ];
    hash = "sha256-RE7eT9s60UIw5D30qVPQ1rugROheqePRfwUnReROZg4=";
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

  meta = with lib; {
    description = "Zsh configuration framework with blazing speed and modular extensions";
    homepage = "https://zimfw.sh";
    license = licenses.mit;
    maintainers = [ maintainers.joedevivo ];
    platforms = platforms.all;
  };
}
