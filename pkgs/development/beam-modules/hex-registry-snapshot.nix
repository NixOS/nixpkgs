{stdenv, writeText, fetchFromGitHub }:

stdenv.mkDerivation rec {
    pname = "hex-registry";
    rev = "11d7a24e9f53f52490ce255a6248e71128e73aa1";
    version = "unstable-2018-07-12";

    src = fetchFromGitHub {
        inherit rev;
        owner  = "erlang-nix";
        repo   = "hex-pm-registry-snapshots";
        sha256 = "0dbpcrdh6jqmvnm1ysmy7ixyc95vnbqmikyx5kk77qwgyd43fqgi";
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
