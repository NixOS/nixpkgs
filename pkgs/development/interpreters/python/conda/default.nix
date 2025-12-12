{ pkgs }:
{

  # List of libraries that are needed for conda binary packages.
  # When installing a conda binary package, just extend
  # the `buildInputs` with `condaAutopatchLibs`.
  condaPatchelfLibs = map (p: p.lib or p) (
    [
      pkgs.alsa-lib
      pkgs.cups
      pkgs.gcc-unwrapped
      pkgs.libGL
    ]
    ++ (with pkgs.xorg; [
      libSM
      libICE
      libX11
      libXau
      libXdamage
      libXi
      libXrender
      libXrandr
      libXcomposite
      libXcursor
      libXtst
      libXScrnSaver
    ])
  );
}
