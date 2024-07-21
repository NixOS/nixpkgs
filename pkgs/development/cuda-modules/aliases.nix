# Packges which have been deprecated or removed from cudaPackages
final: prev:
let
  mkRenamed =
    oldName: newName: newPkg:
    final.lib.warn "cudaPackages.${oldName} is deprecated, use ${newName} instead" newPkg;
in
{

  # Deprecated: an alias kept for compatibility. Consider removing after 24.05
  autoFixElfFiles = mkRenamed "autoFixElfFiles" "pkgs.autoFixElfFiles" final.pkgs.autoFixElfFiles; # Added 2024-03-30
  autoAddDriverRunpath =
    mkRenamed "autoAddDriverRunpath" "pkgs.autoAddDriverRunpath"
      final.pkgs.autoAddDriverRunpath; # Added 2024-03-30
  autoAddOpenGLRunpathHook =
    mkRenamed "autoAddOpenGLRunpathHook" "pkgs.autoAddDriverRunpathHook"
      final.pkgs.autoAddDriverRunpath; # Added 2024-03-30
}
