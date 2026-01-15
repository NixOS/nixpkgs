{
  buildDunePackage,
  mdx,
  yocaml,
  fmt,
  alcotest,
  ppx_expect,
  qcheck,
  qcheck-alcotest,
  logs,
}:

buildDunePackage (finalAttrs: {
  pname = "yocaml_syndication";

  inherit (yocaml)
    version
    src
    ;

  minimalOCamlVersion = "5.1.1";

  propagatedBuildInputs = [
    yocaml
  ];

  doCheck = true;
  nativeCheckInputs = [
    mdx.bin
  ];
  checkInputs = [
    (mdx.override { inherit logs; })
    fmt
    alcotest
    ppx_expect
    qcheck
    qcheck-alcotest
  ];

  meta = yocaml.meta // {
    description = "Yocaml plugin for dealing with RSS and Atom feed";
  };
})
