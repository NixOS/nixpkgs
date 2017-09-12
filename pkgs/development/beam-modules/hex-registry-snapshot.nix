{stdenv, writeText, fetchFromGitHub }:

stdenv.mkDerivation rec {
    name = "hex-registry";
    rev = "9f736e7";
    version = "0.0.0+build.${rev}";

    # src = /home/gleber/code/erl/hex-pm-registry-snapshots;
    src = fetchFromGitHub {
        owner = "erlang-nix";
        repo = "hex-pm-registry-snapshots";
        inherit rev;
        sha256 = "1xiw5yifyk3bbmr0cr82y1nc4c6zk11f6azdv07glb7yrgccrv79";
    };

    installPhase = ''
       mkdir -p "$out/var/hex"
       zcat "registry.ets.gz" > "$out/var/hex/registry.ets"
    '';

    setupHook = writeText "setupHook.sh" ''
        export HEX_REGISTRY_SNAPSHOT="$1/var/hex/registry.ets"
   '';

    meta = {
        platforms = stdenv.lib.platforms.unix;
    };
}
