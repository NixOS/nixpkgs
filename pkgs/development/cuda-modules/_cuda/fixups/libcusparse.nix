{
  cudaAtLeast,
  lib,
  libnvjitlink ? null,
}:
prevAttrs: {
  buildInputs =
    prevAttrs.buildInputs or [ ]
    # Dependency from 12.0 and on
    ++ lib.lists.optionals (cudaAtLeast "12.0") [ libnvjitlink ];

  brokenConditions = prevAttrs.brokenConditions or { } // {
    "libnvjitlink missing (CUDA >= 12.0)" =
      !(cudaAtLeast "12.0" -> (libnvjitlink != null && libnvjitlink != null));
  };
}
