{
  lib,
  libcufft,
  libcurand,
  libGLU,
  libglut,
  libglvnd,
  mesa,
}:
prevAttrs: {
  buildInputs = prevAttrs.buildInputs ++ [
    libcufft
    libcurand
    libGLU
    libglut
    libglvnd
    mesa
  ];
}
