{ runCommand, lndir, newlib, msp430GccSupport }:

runCommand "msp430-${newlib.name}" {
  inherit newlib;
  inherit msp430GccSupport;

  preferLocalBuild = true;
  allowSubstitutes = false;

  passthru = {
    inherit (newlib) incdir libdir;
  };
} ''
  mkdir $out
  ${lndir}/bin/lndir -silent $newlib $out
  ${lndir}/bin/lndir -silent $msp430GccSupport/include $out/${newlib.incdir}
  ${lndir}/bin/lndir -silent $msp430GccSupport/lib $out/${newlib.libdir}
''
