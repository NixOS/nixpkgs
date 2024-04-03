final: _: {
  autoAddCudaCompatRunpath = final.callPackage ./auto-add-cuda-compat-runpath { };
  markForCudatoolkitRootHook = final.callPackage ./mark-for-cudatoolkit-root-hook { };
  setupCudaHook = final.callPackage ./setup-cuda-hook { };
}
