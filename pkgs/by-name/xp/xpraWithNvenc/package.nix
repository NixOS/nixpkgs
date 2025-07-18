{
  xpra,
  linuxPackages,
}:
xpra.override {
  withNvenc = true;
  nvidia_x11 = linuxPackages.nvidia_x11.override { libsOnly = true; };
}
