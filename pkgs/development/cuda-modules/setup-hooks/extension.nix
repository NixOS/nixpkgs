final: _: {
  autoAddCudaCompatRunpath = final.callPackage ./auto-add-cuda-compat-runpath-hook { };
  autoAddDriverRunpath = final.callPackage ./auto-add-driver-runpath-hook { };
  autoFixElfFiles = final.callPackage ./auto-fix-elf-files-hook { };
  markForCudatoolkitRootHook = final.callPackage ./mark-for-cudatoolkit-root-hook { };
  setupCudaHook = final.callPackage ./setup-cuda-hook { };

  # Aliases
  # Deprecated: an alias kept for compatibility. Consider removing after 24.11
  autoAddOpenGLRunpathHook = final.autoAddDriverRunpath;
}
