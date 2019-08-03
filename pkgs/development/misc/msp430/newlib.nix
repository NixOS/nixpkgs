{ stdenvNoCC, lndir, newlib, msp430GccSupport }:

stdenvNoCC.mkDerivation {
  name = "msp430-${newlib.name}";
  inherit newlib;
  inherit msp430GccSupport;

  preferLocalBuild = true;
  allowSubstitutes = false;

  buildCommand = ''
    mkdir $out
    ${lndir}/bin/lndir -silent $newlib $out
    ${lndir}/bin/lndir -silent $msp430GccSupport/include $out/${newlib.incdir}
    ${lndir}/bin/lndir -silent $msp430GccSupport/lib $out/${newlib.libdir}
  '';

  passthru = {
    inherit (newlib) incdir libdir;
  };

  meta = {
    platforms = [ "msp430-none" ];
  };
}
