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
      libsm
      libice
      libx11
      libxau
      libxdamage
      libxi
      libxrender
      libxrandr
      libxcomposite
      libxcursor
      libxtst
      libxscrnsaver
    ]
  );
}
