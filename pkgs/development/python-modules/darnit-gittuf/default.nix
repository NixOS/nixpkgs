{
  buildPythonPackage,
  darnit-core,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "darnit-gittuf";
  inherit (darnit-core) version src;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/packages/darnit-gittuf";

  build-system = [ hatchling ];

  dependencies = [ darnit-core ];

  doCheck = false;

  pythonImportsCheck = [ "darnit_gittuf" ];

  meta = {
    description = "Gittuf policy checks plugin for darnit";
    inherit (darnit-core.meta)
      homepage
      changelog
      license
      maintainers
      ;
  };
})
