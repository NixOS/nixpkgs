{
  cudaAtLeast,
  lib,
  libnvjitlink ? null,
}:
prevAttrs: {
  buildInputs = prevAttrs.buildInputs or [ ] ++ [ libnvjitlink ];

  brokenConditions = prevAttrs.brokenConditions or { } // {
    "libnvjitlink missing (CUDA >= 12.0)" = libnvjitlink == null;
  };
}
