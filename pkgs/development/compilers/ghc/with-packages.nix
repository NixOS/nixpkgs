{ stdenv, ghc, packages, buildEnv, makeWrapper }:

assert packages != [];

let
  ghc761OrLater = stdenv.lib.versionOlder "7.6.1" ghc.version;
  packageDBFlag = if ghc761OrLater then "--package-db" else "--package-conf";
  libDir        = "$out/lib/ghc-${ghc.version}";
  packageCfgDir = "${libDir}/package.conf.d";
  isHaskellPkg  = x: (x ? pname) && (x ? version);
in
buildEnv {
  name = "haskell-env-${ghc.name}";
  paths = stdenv.lib.filter isHaskellPkg (stdenv.lib.closePropagation packages) ++ [ghc];
  postBuild = ''
    . ${makeWrapper}/nix-support/setup-hook

    for prg in ghc ghci ghc-${ghc.version} ghci-${ghc.version}; do
      rm -f $out/bin/$prg
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg         \
        --add-flags '"-B$NIX_GHC_LIBDIR"'               \
        --set "NIX_GHC"        "$out/bin/ghc"           \
        --set "NIX_GHCPKG"     "$out/bin/ghc-pkg"       \
        --set "NIX_GHC_LIBDIR" "${libDir}"
    done

    for prg in runghc runhaskell; do
      rm -f $out/bin/$prg
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg         \
        --add-flags "-f $out/bin/ghc"                   \
        --set "NIX_GHC"        "$out/bin/ghc"           \
        --set "NIX_GHCPKG"     "$out/bin/ghc-pkg"       \
        --set "NIX_GHC_LIBDIR" "${libDir}"
    done

    for prg in ghc-pkg ghc-pkg-${ghc.version}; do
      rm -f $out/bin/$prg
      makeWrapper ${ghc}/bin/$prg $out/bin/$prg --add-flags "${packageDBFlag} ${packageCfgDir}"
    done

    $out/bin/ghc-pkg recache
  '';
}
