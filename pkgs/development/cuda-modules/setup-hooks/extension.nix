final: _: {
  autoAddCudaCompatRunpath = final.callPackage ./auto-add-cuda-compat-runpath { };
  markForCudatoolkitRoot = final.callPackage ./mark-for-cudatoolkit-root { };
  setupCuda = final.callPackage ./setup-cuda { };
}
