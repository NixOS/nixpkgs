args: with args;
{ name, src, meta ? {}, libsFun, pass ? {} } : 
let buildInputs = libsFun ((ghc68extraLibs ghcsAndLibs.ghc68) // ghcsAndLibs.ghc68.core_libs) 
                  ++ [ ghcsAndLibs.ghc68.ghc perl ];
in stdenv.mkDerivation ({
  inherit name src meta;
  phases = "unpackPhase patchPhase buildPhase";
  # TODO The ghc must be the one having compiled the libs.. So make this obvious by not having to pass it
  buildPhase  = ''
    ghc --make Setup.*hs -o setup
    ensureDir \out
    nix_ghc_pkg_tool join local-pkg-db
    ./setup configure --prefix=$out --package-db=local-pkg-db
    ./setup build
    ./setup install
    '';
} // pass // { buildInputs = buildInputs ++  (if pass ? buildInputs then lib.toList pass.buildInputs else []); })
