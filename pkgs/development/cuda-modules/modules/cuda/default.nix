{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib) filesystem trivial versions;

  # Read all the files in the manifests directory
  # manifestFiles :: [ Path ]
  cudaVersionMajor = versions.major config.cudaVersion;
  cudaVersionMinor = versions.minor config.cudaVersion;
  filenameRegexFn = builtins.match ".+(feature|redistrib)_${cudaVersionMajor}\\.${cudaVersionMinor}\\.[[:digit:]]+\\.json$";
  manifests =
    builtins.foldl'
      (
        manifestAttrs: filename:
        let
          matches = filenameRegexFn (builtins.toString filename);
        in
        if matches == null then
          # No matches!
          manifestAttrs
        else
          let
            fileKind =
              trivial.throwIfNot (builtins.length matches == 1)
                "Unexpected error while processing manifest files: multiple regex matches in filename ${builtins.toString filename}"
                (builtins.head matches);
            newAttr =
              trivial.throwIf (builtins.hasAttr fileKind manifestAttrs)
                "Unexpected error while processing manifest files: duplicate file kind ${builtins.toString fileKind}"
                { "${fileKind}" = trivial.importJSON filename; };
          in
          manifestAttrs // newAttr
      )
      { }
      (filesystem.listFilesRecursive ./manifests);
in
{
  options.cuda.manifests = options.generic.manifests;
  config.cuda.manifests =
    # It's okay if neither feature nor redistrib manifests are found, but if one is found, the other must be found as well
    trivial.throwIf (builtins.hasAttr "feature" manifests != builtins.hasAttr "redistrib" manifests)
      "Both feature and redistrib manifests must be present, or neither"
      manifests;
}
