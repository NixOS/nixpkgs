{
  # TODO: fix up and send to upstream
  "gcc/fix-collect2-paths.diff" = [
    {
      after = "15";
      path = ../15;
    }
  ];

  # Submitted (001--003):
  #  - https://gcc.gnu.org/pipermail/gcc-patches/2021-August/577639.html
  #  - https://gcc.gnu.org/pipermail/gcc-patches/2021-August/577640.html
  #  - https://gcc.gnu.org/pipermail/gcc-patches/2021-August/577638.html
  #
  # In Git: https://github.com/Ericson2314/gcc/tree/prog-target-15
  "gcc/0001-find_a_program-First-search-with-machine-prefix.patch" = [
    {
      after = "15";
      path = ../15;
    }
  ];
  "gcc/0002-driver-for_each_pass-Pass-to-callback-whether-dir-is.patch" = [
    {
      after = "15";
      path = ../15;
    }
  ];
  "gcc/0003-find_a_program-Only-search-for-prefixed-paths-in-und.patch" = [
    {
      after = "15";
      path = ../15;
    }
  ];

  # Submitted: https://gcc.gnu.org/pipermail/gcc-patches/2025-July/689429.html
  # In Git: https://github.com/Ericson2314/gcc/tree/libgcc-custom-threading-model-15
  "gcc/custom-threading-model.patch" = [
    {
      after = "15";
      path = ../15;
    }
  ];
}
