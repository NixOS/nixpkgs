{
  buildPythonPackage,
  darnit-core,
  hatchling,
  tree-sitter,
  tree-sitter-language-pack,
}:

buildPythonPackage (finalAttrs: {
  pname = "darnit-baseline";
  inherit (darnit-core) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/packages/darnit-baseline";

  build-system = [ hatchling ];

  # The threat-model parser only uses get_language/get_parser, which are
  # available in older releases too.
  pythonRelaxDeps = [ "tree-sitter-language-pack" ];

  dependencies = [
    darnit-core
    tree-sitter
    tree-sitter-language-pack
  ];

  doCheck = false;

  pythonImportsCheck = [ "darnit_baseline" ];

  meta = {
    description = "OpenSSF Baseline compliance checks for darnit";
    inherit (darnit-core.meta)
      homepage
      changelog
      license
      maintainers
      ;
  };
})
