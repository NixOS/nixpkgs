{
  stdenv,
  runtimeShell,
  lib,
  fetchFromGitHub,
  ibtool,
  xcbuildHook,
}:

stdenv.mkDerivation rec {
  pname = "terminal-notifier";

  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "julienXX";
    repo = "terminal-notifier";
    rev = version;
    sha256 = "sha256-Hd9cI3R2nQK2deBb5CBYz4DTHAEcO4vzqtA5qZwa1Ao=";
  };

  nativeBuildInputs = [
    ibtool
    xcbuildHook
  ];

  installPhase = ''
    mkdir -p $out/Applications
    mkdir -p $out/bin
    cp -r Products/Release/terminal-notifier.app $out/Applications
    cat >$out/bin/terminal-notifier <<EOF
    #!${runtimeShell}
    cd $out/Applications/terminal-notifier.app
    exec ./Contents/MacOS/terminal-notifier "\$@"
    EOF
    chmod +x $out/bin/terminal-notifier
  '';

  meta = {
    maintainers = [ ];
    homepage = "https://github.com/julienXX/terminal-notifier";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "terminal-notifier";
  };
}
