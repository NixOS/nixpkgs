# Packges which have been deprecated or removed from cudaPackages
final: prev: {
  autoAddOpenGLRunpathHook =
    final.callPackage
      (
        { lib, autoAddDriverRunpathHook }:
        lib.warn "autoAddOpenGLRunpathHook has been renamed to autoAddDriverRunpathHook, and moved to top-level pkgs" autoAddDriverRunpathHook
      )
      {};
}
