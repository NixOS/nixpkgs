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
    # Always depends on this
    ++ [ libcublas ]
    # Dependency from 12.0 and on
    ++ lib.lists.optionals (cudaAtLeast "12.0") [ libnvjitlink ]
    # Dependency from 12.1 and on
    ++ lib.lists.optionals (cudaAtLeast "12.1") [ libcusparse ];

  brokenConditions = prevAttrs.brokenConditions or { } // {
    "libnvjitlink missing (CUDA >= 12.0)" =
      !(cudaAtLeast "12.0" -> (libnvjitlink != null && libnvjitlink != null));
    "libcusparse missing (CUDA >= 12.1)" =
      !(cudaAtLeast "12.1" -> (libcusparse != null && libcusparse != null));
  };
}
