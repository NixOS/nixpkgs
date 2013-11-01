{ stdenv, ghc, makeWrapper, coreutils, writeScript }:

let
  ghc761OrLater = !stdenv.lib.versionOlder ghc.version "7.6.1";
  packageDBFlag = if ghc761OrLater then "-package-db" else "-package-conf";

  GHCGetPackages = writeScript "ghc-get-packages.sh" ''
    #! ${stdenv.shell}
    # Usage:
    #  $1: version of GHC
    #  $2: invocation path of GHC
    #  $3: prefix
    version="$1"
    if test -z "$3"; then
      prefix="${packageDBFlag} "
    else
      prefix="$3"
    fi
    PATH="$2:$PATH"
    IFS=":"
    for p in $PATH; do
      PkgDir="$p/../lib/ghc-$version/package.conf.d"
      for i in "$PkgDir/"*.installedconf; do
        # output takes place here
        test -f $i && echo -n " $prefix$i"
      done
    done
    test -f "$2/../lib/ghc-$version/package.conf" && echo -n " $prefix$2/../lib/ghc-$version/package.conf"
  '';

  GHCPackages = writeScript "ghc-packages.sh" ''
    #! ${stdenv.shell} -e
    declare -A GHC_PACKAGES_HASH # using bash4 hashs to get uniq paths

    for arg in $(${GHCGetPackages} ${ghc.version} "$(dirname $0)"); do
      case "$arg" in
        ${packageDBFlag}) ;;
        *)
          CANONICALIZED="$(${coreutils}/bin/readlink -f -- "$arg")"
          GHC_PACKAGES_HASH["$CANONICALIZED"]= ;;
      esac
    done

    for path in ''${!GHC_PACKAGES_HASH[@]}; do
      echo -n "$path:"
    done
  '';

in
stdenv.mkDerivation {
  name = "ghc-${ghc.version}-wrapper";

  buildInputs = [makeWrapper];
  propagatedBuildInputs = [ghc];

  unpackPhase = "true";
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    for prg in ghc ghci ghc-${ghc.version} ghci-${ghc.version}; do
      makeWrapper $ghc/bin/$prg $out/bin/$prg --add-flags "\$(${GHCGetPackages} ${ghc.version} \"\$(dirname \$0)\")"
    done
    for prg in runghc runhaskell; do
      makeWrapper $ghc/bin/$prg $out/bin/$prg --add-flags "\$(${GHCGetPackages} ${ghc.version} \"\$(dirname \$0)\" \" ${packageDBFlag} --ghc-arg=\")"
    done
    for prg in ghc-pkg ghc-pkg-${ghc.version}; do
      makeWrapper $ghc/bin/$prg $out/bin/$prg --add-flags "\$(${GHCGetPackages} ${ghc.version} \"\$(dirname \$0)\" -${packageDBFlag}=)"
    done
    for prg in hp2ps hpc hasktags hsc2hs; do
      test -x $ghc/bin/$prg && ln -s $ghc/bin/$prg $out/bin/$prg
    done

    mkdir -p $out/nix-support
    ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages

    mkdir -p $out/share/doc
    ln -s $ghc/lib $out/lib
    ln -s $ghc/share/doc/ghc $out/share/doc/ghc-${ghc.version}

    runHook postInstall
  '';

  inherit ghc GHCGetPackages GHCPackages;
  inherit (ghc) meta version;
}
