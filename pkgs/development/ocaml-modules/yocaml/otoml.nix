{
  buildDunePackage,
  mdx,
  yocaml,
  otoml,
  logs,
}:

buildDunePackage (finalAttrs: {
  pname = "yocaml_otoml";

  inherit (yocaml)
    version
    src
    ;

  minimalOCamlVersion = "5.1.1";

  propagatedBuildInputs = [
    yocaml
    otoml
  ];

  doCheck = true;
  nativeCheckInputs = [
    mdx.bin
  ];
  checkInputs = [
    (mdx.override { inherit logs; })
  ];

  meta = yocaml.meta // {
    description = "Plugin for describing metadata with TOML, based on the OTOML package";
  };
})
