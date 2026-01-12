{ pkgs }:
{

  # List of libraries that are needed for conda binary packages.
  # When installing a conda binary package, just extend
  # the `buildInputs` with `condaAutopatchLibs`.
  condaPatchelfLibs = map (p: p.lib or p) (
    with pkgs;
    [
      alsa-lib
      cups
      gcc-unwrapped
      libGL
      xorg.libSM
      libice
      xorg.libX11
      xorg.libXau
      xorg.libXdamage
      xorg.libXi
      xorg.libXrender
      xorg.libXrandr
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXtst
      xorg.libXScrnSaver
    ]
  );
}
