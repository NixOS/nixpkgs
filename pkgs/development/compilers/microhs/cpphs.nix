{
  args,
  hugs,
  microhs,
  stdenv,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    args' = args finalAttrs;
  in
  args'
  // {
    pname = "microhs-cpphs";

    nativeBuildInputs = [ hugs ];

    makeFlags = [ "USECPPHS=$(TMP)/cpphs-boot" ];
    buildFlags = [
      "bootstrapcpphs"
      "bin/cpphs"
    ];

    # Generate cpphs-boot and populate paths that the target uses
    # We can't use cpphs-hugs directly because it's too primitive
    preBuild = ''
      mkdir -p $TMP/cpphs-hugs/src
      cp -r hugs/* cpphscompat/* cpphssrc/malcolm-wallace-universe/{polyparse-*/src,cpphs-*}/* $TMP/cpphs-hugs/src/
      find $TMP/cpphs-hugs/src -type f -name '*.hs' -exec ${hugs}/bin/cpphs-hugs --noline '{}' '-O{}.tmp' \;
      find $TMP/cpphs-hugs/src -type f -name '*.hs' -exec mv '{}.tmp' '{}' \;
      sed -i -e '/fail *= *Fail\.fail/d' $TMP/cpphs-hugs/src/Text/ParserCombinators/Poly/Parser.hs

      ${microhs}/bin/mhs -l -i$TMP/cpphs-hugs/src $TMP/cpphs-hugs/src/cpphs.hs -o$TMP/cpphs-boot

      mkdir -p bin generated
      ln -s ${microhs}/bin/mhs bin/mhs
      touch cpphssrc/malcolm-wallace-universe/.git
    '';

    installPhase = ''
      runHook preInstall
      install -m755 -d $out/bin
      install -m755 bin/cpphs $out/bin/cpphs
      runHook postInstall
    '';
  }
)
