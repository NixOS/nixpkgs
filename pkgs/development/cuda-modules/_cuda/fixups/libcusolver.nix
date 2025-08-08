{
  cudaAtLeast,
  lib,
  libcublas,
  libcusparse ? null,
  libnvjitlink ? null,
}:
prevAttrs: {
  buildInputs =
    prevAttrs.buildInputs or [ ]
    # Always depends on these
    ++ [
      libcublas
      libnvjitlink
    ]
    # Dependency from 12.1 and on
    ++ lib.lists.optionals (cudaAtLeast "12.1") [ libcusparse ];

  brokenConditions = prevAttrs.brokenConditions or { } // {
    "libnvjitlink missing" = !(libnvjitlink != null);
    "libcusparse missing (CUDA >= 12.1)" =
      !(cudaAtLeast "12.1" -> (libcusparse != null && libcusparse != null));
  };
}
