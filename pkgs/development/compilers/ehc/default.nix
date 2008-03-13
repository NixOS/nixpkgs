{stdenv, coreutils, fetchsvn, m4, ghc, uulib, uuagc}:

stdenv.mkDerivation (rec {
  name = "ehc-svn-1033";
  homepage = "http://www.cs.uu.nl/wiki/Ehc/WebHome/";

  src = fetchsvn {
          url = https://svn.cs.uu.nl:12443/repos/EHC/trunk/EHC;
          rev = "1033";
          sha256 = "bee6271b81bb1781b086b3c102c6a8205df6d7fca073f2492817717a2553e7af";
  };

  buildInputs = [coreutils m4 ghc uulib uuagc];

  preConfigure = ''
    find src -name files\*.mk -exec sed -i -- "s/--user//g" '{}' \;
    sed -i "s|/bin/date|${coreutils}/bin/date|g" mk/dist.mk
  '';

  buildFlags = "100/ehc";

  installPhase = ''
    mkdir -p $out/bin
    cd bin
    for i in *; do
      if [[ -d $i ]]; then
        cp $i/ehc $out/bin/ehc-$i
      fi;
    done
    mkdir -p $out/lib/ehc
    exit 1
  '';

  meta = {
    description = "Essential Haskell Compiler";
  };

  inherit coreutils;
})
