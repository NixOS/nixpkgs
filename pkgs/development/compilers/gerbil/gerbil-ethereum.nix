{ lib, fetchFromGitHub, gerbilPackages, gerbil-support, gerbil, ... }:

rec {
  pname = "gerbil-ethereum";
  version = "unstable-2023-12-04";
  git-version = "0.2-11-g124ec58";
  softwareName = "Gerbil-ethereum";
  gerbil-package = "clan/ethereum";
  version-path = "version";

  gerbilInputs = with gerbilPackages; [
    gerbil-utils gerbil-crypto gerbil-poo gerbil-persist gerbil-leveldb ];

  pre-src = {
    fun = fetchFromGitHub;
    owner = "mighty-gerbils";
    repo = "gerbil-ethereum";
    rev = "124ec585157e2c505cd3c449a389c124ca6da9e9";
    sha256 = "0xg07k421r5p0qx98id66k0k2l3vi1is875857sd8q3h6bks0z54";
  };

  postInstall = ''
    cp scripts/{croesus.prv,genesis.json,logback.xml,yolo-evm.conf,yolo-kevm.conf,run-ethereum-test-net.ss} $out/gerbil/lib/clan/ethereum/scripts/
    mkdir -p $out/bin
    cat > $out/bin/run-ethereum-test-net <<EOF
    #!/bin/sh
    #|
    ORIG_GERBIL_LOADPATH="\$GERBIL_LOADPATH"
    ORIG_GERBIL_PATH="\$GERBIL_PATH"
    ORIG_GERBIL_HOME="\$GERBIL_HOME"
    unset GERBIL_HOME
    GERBIL_LOADPATH="${gerbil-support.gerbilLoadPath (["$out"] ++ gerbilInputs)}"
    GERBIL_PATH="\$HOME/.cache/gerbil-ethereum/gerbil"
    export GERBIL_PATH GERBIL_LOADPATH GLOW_SOURCE ORIG_GERBIL_PATH ORIG_GERBIL_LOADPATH
    exec ${gerbil}/bin/gxi "\$0" "\$@"
    |#
    (import :clan/ethereum/scripts/run-ethereum-test-net :std/lib/multicall)
    (apply call-entry-point (cdr (command-line)))
    EOF
    chmod a+x $out/bin/run-ethereum-test-net
    '';

  meta = with lib; {
    description = "Gerbil Ethereum: a Scheme alternative to web3.js";
    homepage    = "https://github.com/fare/gerbil-ethereum";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
}
