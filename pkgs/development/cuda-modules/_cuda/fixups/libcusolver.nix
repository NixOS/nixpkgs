{
  lib,
  libcublas,
  libcusparse,
  libnvjitlink,
}:
prevAttrs: {
  buildInputs = prevAttrs.buildInputs or [ ] ++ [
    (lib.getLib libcublas)
    (lib.getLib libcusparse)
    libnvjitlink
  ];

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
        "include"
        "lib"
        "static"
        "stubs"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Collection of dense and sparse direct linear solvers and Eigen solvers";
    longDescription = ''
      The NVIDIA cuSOLVER library provides a collection of dense and sparse direct linear solvers and Eigen solvers
      which deliver significant acceleration for Computer Vision, CFD, Computational Chemistry, and Linear
      Optimization applications.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://developer.nvidia.com/cusolver";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/libcusolver";
  };
}
