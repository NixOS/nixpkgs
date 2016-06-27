{ stdenv, lib, libobjc2, clang, make, makeWrapper, which }:
{ buildInputs ? []
, ...} @ args:
stdenv.mkDerivation (args // {
  buildInputs = [ makeWrapper make which ] ++ buildInputs;

  builder = ./builder.sh;
  setupHook = ./setup-hook.sh;

  GNUSTEP_MAKEFILES = "${make}/share/GNUstep/Makefiles";
})
