{ stdenv, mueval, makeWrapper, ghc
, show, simpleReflect, mtl, random, QuickCheck
, additionalPackages ? [] }:

stdenv.mkDerivation {
  name = "mueval-wrapper";

  buildInputs = [ makeWrapper show simpleReflect mtl random QuickCheck ]
    ++ additionalPackages;

  ghcVersion = ghc.version;

  buildCommand = ''
    PKGPATH=""
    for p in $nativePkgs; do
      for i in "$p/lib/ghc-$ghcVersion/package.conf.d/"*.installedconf; do
        PKGPATH=$PKGPATH''${PKGPATH:+:}$i
      done
    done

    makeWrapper "${mueval}/bin/mueval" "$out/bin/mueval" \
      --prefix PATH : "${mueval}/bin" \
      --prefix GHC_PACKAGE_PATH : "$PKGPATH" \
      --set GHC_PACKAGE_PATH "\$GHC_PACKAGE_PATH:" # always end with : to include base packages
  '';

  preferLocalBuild = true;

  meta = {
    description = mueval.meta.description;
  };
}

