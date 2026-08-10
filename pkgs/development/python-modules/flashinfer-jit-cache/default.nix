{
  flashinfer-python,
  symlinkJoin,
  cudaPackages,
}:

flashinfer-python.overrideAttrs (oldAttrs: {
  pname = "flashinfer-jit-cache";

  sourceRoot = "${oldAttrs.src.name}/flashinfer-jit-cache";
  postUnpack = ''
    # Since we have set `sourceRoot` to a subdir of the actual upstream
    # source, stdenv performs `u+w` recursively only on `sourceRoot`.
    # But, we need parts of `src` to be writeable so lets' just do it
    # indiscriminately.
    chmod -R u+w ${oldAttrs.src.name}
  '';

  env = (oldAttrs.env) // {
    # Though setting `CUDA_HOME` to `${cudaPackages.cuda_nvcc}.out`
    # might work elsewhere, it fails here because flashinfer does some
    # hardcoding. Easier to just create a custom environment than
    # fixing flashinfer's behaviour.
    CUDA_HOME = symlinkJoin {
      name = "cuda-home";
      paths = oldAttrs.buildInputs ++ [ cudaPackages.cuda_nvcc ];
      postBuild = "ln -s lib $out/lib64";
    };
  };
})
