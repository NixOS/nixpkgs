{
  buildDunePackage,
  mdx,
  httpcats,
  yocaml,
  yocaml_runtime,
  logs,
}:

buildDunePackage (finalAttrs: {
  pname = "yocaml_unix";

  inherit (yocaml)
    version
    src
    ;

  minimalOCamlVersion = "5.1.1";

  propagatedBuildInputs = [
    httpcats
    yocaml
    yocaml_runtime
  ];

  doCheck = true;
  nativeCheckInputs = [
    mdx.bin
  ];
  checkInputs = [
    (mdx.override { inherit logs; })
  ];

  meta = yocaml.meta // {
    description = "The Unix runtime for YOCaml";
  };
})
