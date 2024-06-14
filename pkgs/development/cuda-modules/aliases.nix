# Packges which have been deprecated or removed from cudaPackages
final:
let
  mkRenamed =
    oldName: newName: newPkg:
    final.lib.warn "cudaPackages.${oldName} is deprecated, use ${newName} instead" newPkg;
in
{ }
