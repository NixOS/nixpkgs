{
  lib,
  buildEnv,
  typstPackages,
  makeBinaryWrapper,
  typst,
}:

lib.makeOverridable (
  { ... }@typstPkgs:
  f:
  let
    preparedTypstDeps = f typstPkgs;
    expandTypstDeps =
      ps:
      if ps == [ ] then
        ps
      else
        lib.foldl' (acc: p: acc ++ lib.singleton p ++ expandTypstDeps p.typstDeps) [ ] ps;
  in
  buildEnv {
    name = "${typst.name}-env";

    paths = lib.unique (expandTypstDeps preparedTypstDeps);

    nativeBuildInputs = [ makeBinaryWrapper ];

    postBuild = ''
      export TYPST_LIB_DIR="$out/lib/typst/packages"
      mkdir -p $TYPST_LIB_DIR/preview

      for path in $(find $out -type l); do
        mv $path $TYPST_LIB_DIR/preview
      done

      cp -r ${typst}/share $out/share
      mkdir -p $out/bin

      makeWrapper "${lib.getExe typst}" "$out/bin/typst" --set TYPST_PACKAGE_CACHE_PATH $TYPST_LIB_DIR
    '';
  }
) typstPackages
