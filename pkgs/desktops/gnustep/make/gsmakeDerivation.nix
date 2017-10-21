{ stdenv, lib, make, makeWrapper, which }:
{ buildInputs ? [], ...} @ args:
stdenv.mkDerivation (args // {
  buildInputs = [ makeWrapper make which ] ++ buildInputs;

  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;

  GNUSTEP_MAKEFILES = "${make}/share/GNUstep/Makefiles";

  meta = {
    homepage = http://gnustep.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ ashalkhakov matthewbauer ];
    platforms = stdenv.lib.platforms.linux;
  } // (if builtins.hasAttr "meta" args then args.meta else {});
})
