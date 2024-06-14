{
  freeglut,
  libcufft,
  libcurand,
  libGLU,
  libglvnd,
  mesa,
}:
prevAttrs: {
  buildInputs = prevAttrs.buildInputs ++ [
    freeglut
    libcufft.lib
    libcurand.lib
    libGLU
    libglvnd
    mesa
  ];
}
