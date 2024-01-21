{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "CoinMP";
  version = "1.8.4";

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/CoinMP/${pname}-${version}.tgz";
    sha256 = "13d3j1sdcjzpijp4qks3n0zibk649ac3hhv88hkk8ffxrc6gnn9l";
  };

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://projects.coin-or.org/CoinMP/";
    description = "COIN-OR lightweight API for COIN-OR libraries CLP, CBC, and CGL";
    platforms = platforms.unix;
    license = licenses.epl10;
    # Broken for Darwin at 2024-01-21
    # Log failure:
    #   aarch64-darwin: https://hydra.nixos.org/build/246540922/nixlog/1
    #   x86_64-darwin: https://hydra.nixos.org/build/246525811/nixlog/1
    # Tracking issue:
    #   https://github.com/NixOS/nixpkgs/issues/282606
    broken = stdenv.hostPlatform.isDarwin;
  };
}
