{
  xpra,
  nvidiaPackages,
}:
xpra.override {
  withNvenc = true;
  nvidia_x11 = nvidiaPackages.stable.driver.override { libsOnly = true; };
}
