{
  libglut,
  libcufft,
  libcurand,
  libGLU,
  libglvnd,
  libgbm,
}:
prevAttrs: {
  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    libglut
    libcufft
    libcurand
    libGLU
    libglvnd
    libgbm
  ];
}
