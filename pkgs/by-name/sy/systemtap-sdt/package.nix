{ linuxPackages }:
linuxPackages.systemtap.override {
  withStap = false;
}
// {
  meta = linuxPackages.systemtap.meta // {
    description = "Build USDT tracepoints with the 'dtrace' executable on Linux";
    mainProgram = "dtrace";
  };
}
