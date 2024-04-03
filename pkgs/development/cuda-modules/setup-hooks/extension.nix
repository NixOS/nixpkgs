final: _: {
  autoAddCudaCompatRunpath = final.callPackage ./auto-add-cuda-compat-runpath { };
  markForCudatoolkitRoot = final.callPackage ./mark-for-cudatoolkit-root { };
  setupCudaHook = final.callPackage ./setup-cuda-hook { };
}
