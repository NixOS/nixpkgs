{ stdenvNoCC, xorg, newlib, msp430GccSupport }:

stdenvNoCC.mkDerivation {
  name = "msp430-${newlib.name}";
  inherit newlib;
  inherit msp430GccSupport;

  preferLocalBuild = true;
  allowSubstitutes = false;

  depsBuildBuild = [ xorg.lndir ];

  buildCommand = ''
    mkdir $out
    lndir -silent $newlib $out
    lndir -silent $msp430GccSupport/include $out/${newlib.incdir}
    lndir -silent $msp430GccSupport/lib $out/${newlib.libdir}
  '';

  passthru = {
    inherit (newlib) incdir libdir;
  };

  meta = {
    platforms = [ "msp430-none" ];
  };
}
