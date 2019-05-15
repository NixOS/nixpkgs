{ pkgs }:

{
  autocrop = pkgs.callPackage ./autocrop { };

  beziercurve = pkgs.callPackage ./beziercurve { };

  # why ffms2? it's the real name of the library and how it's referred to in vapoursynth
  ffms2 = pkgs.ffms;

  mvtools = pkgs.callPackage ./mvtools { };
}
