{
  # TODO: fix up and send to upstream
  "gcc/fix-collect2-paths.diff" = [
    # GCC 16 spells one context line with the C++ `const_cast` operator rather
    # than the `CONST_CAST2` macro, and excludes one more linker (`wild`) from
    # the target-prefixed names, so the patch had to be rebased.
    {
      after = "16";
      path = ../16;
    }
    {
      after = "15";
      path = ../15;
    }
  ];

  # Only present under `../16`, so a `gitRelease` build -- whose version
  # directory is `../git` -- has to be pointed here too.
  "libatomic/no-gcc-objdir-install.patch" = [
    {
      after = "16";
      path = ../16;
    }
  ];

  # As above: only under `../16`, so name it for `gitRelease` builds too.
  "libgomp/uid-buffer-size.patch" = [
    {
      after = "16";
      path = ../16;
    }
  ];

  # Paired by version, as the monolithic set pairs them: 14's variant for 16,
  # 15's for 15.
  "libgcc/darwin-detection.patch" = [
    {
      after = "16";
      path = ../16;
    }
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
    # GCC 16 grew a second coarray library, `libcaf_shmem`, sharing the
    # `cafexeclib` prefix this removes, so the patch had to be rebased.
    {
      after = "16";
      path = ../16;
    }
    {
      after = "15";
      path = ../15;
    }
  ];
}
