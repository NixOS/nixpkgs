{
  buildDunePackage,
  mdx,
  yocaml,
  cmarkit,
  logs,
}:

buildDunePackage (finalAttrs: {
  pname = "yocaml_cmarkit";

  inherit (yocaml)
    version
    src
    ;

  minimalOCamlVersion = "5.1.1";

  propagatedBuildInputs = [
    cmarkit
    yocaml
  ];

  doCheck = true;
  nativeCheckInputs = [
    mdx.bin
  ];
  checkInputs = [
    (mdx.override { inherit logs; })
  ];

  meta = yocaml.meta // {
    description = "Yocaml plugin for using Markdown (via Cmarkit package) as a Markup language";
  };
})
