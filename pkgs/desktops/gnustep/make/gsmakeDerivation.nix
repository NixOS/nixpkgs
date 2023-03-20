{ lib, stdenv, make, makeWrapper, which }:
{ nativeBuildInputs ? [], ...} @ args:
stdenv.mkDerivation (args // {
  nativeBuildInputs = [ makeWrapper make which ] ++ nativeBuildInputs;

  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;

  GNUSTEP_MAKEFILES = "${make}/share/GNUstep/Makefiles";

  meta = {
    homepage = "http://gnustep.org/";

    license = lib.licenses.lgpl2Plus;

    maintainers = with lib.maintainers; [ ashalkhakov matthewbauer ];
    platforms = lib.platforms.linux;
  } // (if builtins.hasAttr "meta" args then args.meta else {});
})
