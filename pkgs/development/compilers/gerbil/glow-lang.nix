{ lib, fetchFromGitLab, gerbil-support, gerbilPackages, gerbil, ... }:

rec {
  pname = "glow-lang";
  version = "unstable-2021-09-12";
  git-version = "0.3.1";
  softwareName = "Glow";
  gerbil-package = "mukn/glow";
  version-path = "version";

  gerbilInputs = with gerbilPackages;
    [ gerbil-utils gerbil-crypto gerbil-poo gerbil-persist gerbil-ethereum
      gerbil-libp2p smug-gerbil ftw ];

  pre-src = {
    fun = fetchFromGitLab;
    owner = "mukn";
    repo = "glow";
    rev = "b8062a3bcf27c9c87ae591a59d6734e76931f644";
    sha256 = "0izq60hssw48qh5zbnhqq5b4v38dcc05sgls9p71510fix6qgpp8";
    };

  postPatch = ''
    substituteInPlace "runtime/glow-path.ss" --replace \
      '(def glow-install-path (source-path "dapps"))' \
      '(def glow-install-path "$out")'
  '';

  postInstall = ''
    mkdir -p $out/bin $out/gerbil/lib/mukn/glow $out/share/glow/dapps
    cp main.ss $out/gerbil/lib/mukn/glow/
    cp dapps/{buy_sig,coin_flip,rps_simple}.glow $out/share/glow/dapps/
    cat > $out/bin/glow <<EOF
    #!/bin/sh
    ORIG_GERBIL_LOADPATH="\$GERBIL_LOADPATH"
    ORIG_GERBIL_PATH="\$GERBIL_PATH"
    ORIG_GERBIL_HOME="\$GERBIL_HOME"
    unset GERBIL_HOME
    GERBIL_LOADPATH="${gerbil-support.gerbilLoadPath (["$out"] ++ gerbilInputs)}"
    GLOW_SOURCE="\''${GLOW_SOURCE:-$out/share/glow}"
    GERBIL_PATH="\$HOME/.cache/glow/gerbil"
    export GERBIL_PATH GERBIL_LOADPATH GLOW_SOURCE ORIG_GERBIL_PATH ORIG_GERBIL_LOADPATH ORIG_GERBIL_HOME
    exec ${gerbil}/bin/gxi $out/gerbil/lib/mukn/glow/main.ss "\$@"
    EOF
    chmod a+x $out/bin/glow
    '';

  meta = with lib; {
    description = "Glow: language for safe Decentralized Applications (DApps)";
    homepage    = "https://glow-lang.org";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
