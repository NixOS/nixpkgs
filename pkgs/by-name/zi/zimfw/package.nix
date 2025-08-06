{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "zimfw";
  version = "1.18.0";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "zimfw";
    tag = "v${version}";
    ## zim only needs this one file to be installed.
    sparseCheckout = [ "zimfw.zsh" ];
    hash = "sha256-qQViaQOpLp8F4zvJETbNp0lxpdVhM1Meg7WcMKkjJRQ=";
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
