{
  cudaAtLeast,
  lib,
  libcublas,
  libcusparse ? null,
  libnvjitlink ? null,
}:
prevAttrs: {
  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    libcublas
    libnvjitlink
    libcusparse
  ];

  brokenConditions = prevAttrs.brokenConditions or { } // {
    "libnvjitlink missing (CUDA >= 12.0)" = libnvjitlink == null;
    "libcusparse missing (CUDA >= 12.1)" = libcusparse == null;
  };
}
