{ stdenv, callPackage }:

stdenv.lib.overrideDerivation (callPackage ./package.nix { }) (x: {
  postPatch = ''
    rm Setup.hs
  '';
})
