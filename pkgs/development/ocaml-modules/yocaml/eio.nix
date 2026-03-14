{
  buildDunePackage,
  mdx,
  yocaml,
  yocaml_runtime,
  eio,
  eio_main,
  cohttp-eio,
  logs,
  magic-mime,
}:

buildDunePackage (finalAttrs: {
  pname = "yocaml_eio";

  inherit (yocaml)
    version
    src
    ;

  minimalOCamlVersion = "5.1.1";

  propagatedBuildInputs = [
    yocaml
    yocaml_runtime
    eio
    eio_main
    cohttp-eio
    magic-mime
  ];

  doCheck = true;
  nativeCheckInputs = [
    mdx.bin
  ];
  checkInputs = [
    (mdx.override { inherit logs; })
  ];

  meta = yocaml.meta // {
    description = "The Eio runtime for YOCaml";
  };
})
