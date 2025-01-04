{
  stdenv,
  runtimeShell,
  lib,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "terminal-notifier";

  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/alloy/terminal-notifier/releases/download/${version}/terminal-notifier-${version}.zip";
    sha256 = "0gi54v92hi1fkryxlz3k5s5d8h0s66cc57ds0vbm1m1qk3z4xhb0";
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/Applications
    mkdir -p $out/bin
    cp -r terminal-notifier.app $out/Applications
    cat >$out/bin/terminal-notifier <<EOF
    #!${runtimeShell}
    cd $out/Applications/terminal-notifier.app
    exec ./Contents/MacOS/terminal-notifier "\$@"
    EOF
    chmod +x $out/bin/terminal-notifier
  '';

  meta = with lib; {
    maintainers = [ ];
    homepage = "https://github.com/julienXX/terminal-notifier";
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
