{
  buildDunePackage,
  mdx,
  yocaml,
  mustache,
  logs,
}:

buildDunePackage (finalAttrs: {
  pname = "yocaml_mustache";

  inherit (yocaml)
    version
    src
    ;

  minimalOCamlVersion = "5.1.1";

  propagatedBuildInputs = [
    yocaml
    mustache
  ];

  doCheck = true;
  nativeCheckInputs = [
    mdx.bin
  ];
  checkInputs = [
    (mdx.override { inherit logs; })
  ];

  meta = yocaml.meta // {
    description = "Yocaml plugin for using Mustache as a template language";
  };
})
