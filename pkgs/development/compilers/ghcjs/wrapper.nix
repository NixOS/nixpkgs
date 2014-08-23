{ stdenv, ghc, makeWrapper, coreutils, writeScript }:
let
  ghcjs = ghc;
  packageDBFlag = "-package-db";

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
    PATH="$PATH:$2"
    IFS=":"
    for p in $PATH; do
      for i in "$p/../share/ghcjs/$system-${ghcjs.version}-${ghcjs.ghc.version}"{,/lib,/ghcjs}"/package.conf.d" "$p/../lib/ghcjs-${ghc.version}_ghc-${ghc.ghc.version}/package.conf.d" ; do
        # output takes place here
        test -f $i/package.cache && echo -n " $prefix$i"
      done
    done
  '';

  GHCPackages = writeScript "ghc-packages.sh" ''
    #! ${stdenv.shell} -e
    declare -A GHC_PACKAGES_HASH # using bash4 hashs to get uniq paths

    for arg in $(${GHCGetPackages} ${ghcjs.version} "$(dirname $0)"); do # Why is ghc.version passed in from here instead of captured in the other script directly?
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
  name = "ghcjs-ghc${ghcjs.ghc.version}-${ghcjs.version}-wrapper";

  buildInputs = [makeWrapper];
  propagatedBuildInputs = [ghcjs];

  unpackPhase = "true";
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    for prg in ghcjs ; do
      makeWrapper $ghc/bin/$prg $out/bin/$prg --add-flags "\$(${GHCGetPackages} ${ghcjs.version} \"\$(dirname \$0)\")"
    done
    for prg in ghcjs-pkg ; do
      makeWrapper $ghc/bin/$prg $out/bin/$prg --add-flags "\$(${GHCGetPackages} ${ghcjs.version} \"\$(dirname \$0)\" -${packageDBFlag}=)"
    done

    mkdir -p $out/nix-support
    ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages

    mkdir -p $out/share/doc
    ln -s $ghc/lib $out/lib
    ln -s $ghc/share/doc/ghc $out/share/doc/ghc-${ghcjs.version}

    runHook postInstall
  '';

  ghc = ghcjs;
  inherit GHCGetPackages GHCPackages;
  inherit (ghcjs) meta version;
}
