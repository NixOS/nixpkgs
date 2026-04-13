{
  buildDunePackage,
  mdx,
  yocaml,
  yaml,
  logs,
}:

buildDunePackage (finalAttrs: {
  pname = "yocaml_yaml";

  inherit (yocaml)
    version
    src
    ;

  minimalOCamlVersion = "5.1.1";

  propagatedBuildInputs = [
    yocaml
    yaml
  ];

  doCheck = true;
  nativeCheckInputs = [
    mdx.bin
  ];
  checkInputs = [
    (mdx.override { inherit logs; })
  ];

  meta = yocaml.meta // {
    description = "Yocaml plugin for dealing with Yaml as metadata provider";
  };
})
