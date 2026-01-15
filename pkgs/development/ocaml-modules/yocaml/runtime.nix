{
  buildDunePackage,
  yocaml,
  mdx,
  fmt,
  digestif,
  logs,
}:

buildDunePackage (finalAttrs: {
  pname = "yocaml_runtime";
  inherit (yocaml)
    src
    version
    ;

  minimalOCamlVersion = "5.1.1";

  propagatedBuildInputs = [
    digestif
    fmt
    logs
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
    description = "Tool for describing runtimes (using Logs and Digestif)";
  };
})
