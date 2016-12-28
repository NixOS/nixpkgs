{stdenv, writeText, fetchFromGitHub }:

stdenv.mkDerivation rec {
    name = "hex-registry";
    rev = "e5e494a";
    version = "0.0.0+build.${rev}";

    src = fetchFromGitHub {
        owner = "erlang-nix";
        repo = "hex-pm-registry-snapshots";
        inherit rev;
        sha256 = "0877dragfxs22a05d8mv42z5535kfx9rs4y7fwwbd1ybphczf8za";
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
