{ ghc, lib, makeWrapper, perl }:
let
  ghc761OrLater = lib.versionOlder "7.6.1" ghc.version;
  packageDBFlag = if ghc761OrLater then "--global-package-db" else "--global-conf";
  libDir        = "$out/lib/ghc-${ghc.version}";
  docDir        = "$out/share/doc/ghc/html";
  packageCfgDir = "${libDir}/package.conf.d";
in { ignoreCollisions, paths }:
if paths == [] then "ln -s ${ghc} $out" else ''
export pathsToLink="/"
export manifest=""
export paths="${lib.concatStringsSep " " (paths ++ [ghc])}"
export ignoreCollisions="${builtins.toString ignoreCollisions}"
. ${makeWrapper}/nix-support/setup-hook

${perl}/bin/perl -w ${../../build-support/buildenv/builder.pl}

if test -L "$out/bin"; then
  binTarget="$(readlink -f "$out/bin")"
  rm "$out/bin"
  cp -r "$binTarget" "$out/bin"
  chmod u+w "$out/bin"
fi

for prg in ghc ghci ghc-${ghc.version} ghci-${ghc.version}; do
  rm -f $out/bin/$prg
  makeWrapper ${ghc}/bin/$prg $out/bin/$prg         \
    --add-flags '"-B$NIX_GHC_LIBDIR"'               \
    --set "NIX_GHC"        "$out/bin/ghc"           \
    --set "NIX_GHCPKG"     "$out/bin/ghc-pkg"       \
    --set "NIX_GHC_DOCDIR" "${docDir}"              \
    --set "NIX_GHC_LIBDIR" "${libDir}"
done

for prg in runghc runhaskell; do
  rm -f $out/bin/$prg
  makeWrapper ${ghc}/bin/$prg $out/bin/$prg         \
    --add-flags "-f $out/bin/ghc"                   \
    --set "NIX_GHC"        "$out/bin/ghc"           \
    --set "NIX_GHCPKG"     "$out/bin/ghc-pkg"       \
    --set "NIX_GHC_DOCDIR" "${docDir}"              \
    --set "NIX_GHC_LIBDIR" "${libDir}"
done

for prg in ghc-pkg ghc-pkg-${ghc.version}; do
  rm -f $out/bin/$prg
  makeWrapper ${ghc}/bin/$prg $out/bin/$prg --add-flags "${packageDBFlag}=${packageCfgDir}"
done

export NIX_GHC=$out/bin/ghc
export NIC_GHCPKG=$out/bin/ghc-pkg
export NIX_GHC_DOCDIR="${docDir}"
export NIX_GHC_LIBDIR="${libDir}"

$out/bin/ghc-pkg recache
$out/bin/ghc-pkg check
''
