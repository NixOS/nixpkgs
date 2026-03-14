{
  buildDunePackage,
  mdx,
  yocaml,
  jingoo,
  logs,
}:

buildDunePackage (finalAttrs: {
  pname = "yocaml_jingoo";

  inherit (yocaml)
    version
    src
    ;

  minimalOCamlVersion = "5.1.1";

  propagatedBuildInputs = [
    yocaml
    jingoo
  ];

  doCheck = true;
  nativeCheckInputs = [
    mdx.bin
  ];
  checkInputs = [
    (mdx.override { inherit logs; })
  ];

  meta = yocaml.meta // {
    description = "Yocaml plugin for using Jingoo as a template language";
  };
})
