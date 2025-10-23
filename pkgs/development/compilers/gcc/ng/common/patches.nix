{
  # TODO: fix up and send to upstream
  "gcc/fix-collect2-paths.diff" = [
    {
      after = "15";
      path = ../15;
    }
  ];

  # In Git: https://github.com/Ericson2314/gcc/tree/regular-dirs-in-libgcc-15
  "libgcc/force-regular-dirs.patch" = [
    {
      after = "15";
      path = ../15;
    }
  ];
  # In Git: https://github.com/Ericson2314/gcc/tree/regular-dirs-in-libssp-15
  "libssp/force-regular-dirs.patch" = [
    {
      after = "15";
      path = ../15;
    }
  ];
  # In Git: https://github.com/Ericson2314/gcc/tree/libstdcxx-force-regular-dirs-15
  "libstdcxx/force-regular-dirs.patch" = [
    {
      after = "15";
      path = ../15;
    }
  ];
  # In Git: https://github.com/Ericson2314/gcc/tree/libgfortran-force-regular-dirs-15
  "libgfortran/force-regular-dirs.patch" = [
    {
      after = "15";
      path = ../15;
    }
  ];
}
