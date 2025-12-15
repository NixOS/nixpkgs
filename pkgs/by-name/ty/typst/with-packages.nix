{
  lib,
  buildEnv,
  typstPackages,
  makeBinaryWrapper,
  typst,
}:
buildEnv {
  inherit (typst) version;
  pname = typst.pname + "-env";
  name = typst.pname + "-env-" + typst.version;

  paths = lib.concatMap (p: [ p ] ++ p.propagatedBuildInputs) typstPackages;

  pathsToLink = [
    # The packages
    "/lib/typst/packages"
    # The Typst executable & completions
    "/bin"
    "/share"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/typst" \
      --set TYPST_PACKAGE_CACHE_PATH $TYPST_LIB_DIR
  '';

  meta = builtins.removeAttrs typst.meta [ "position" ];
}
