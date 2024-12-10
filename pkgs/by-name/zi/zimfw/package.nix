{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "zimfw";
  version = "1.15.0";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "zimfw";
    rev = "v${version}";
    ## zim only needs this one file to be installed.
    sparseCheckout = [ "zimfw.zsh" ];
    hash = "sha256-8GnxUhBvMy7fhDILDKYEf/9Mhgzz7suaiZ5elRZmT0o=";
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
    description = "The Zsh configuration framework with blazing speed and modular extensions";
    homepage = "https://zimfw.sh";
    license = licenses.mit;
    maintainers = [ maintainers.joedevivo ];
    platforms = platforms.all;
  };
}
