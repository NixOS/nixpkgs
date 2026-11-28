{
  buildDunePackage,
  console,
  eio,
  mtime,
  fmt,
  logs,
  odoc,
  matrix,
  cstruct,
  eio_main,
  jsont,
  bytesrw,
  alcobar,
  alcotest,
  astring,
  cmdliner,
  mdx,
  k7,
}:

buildDunePackage {
  pname = "console-eio";
  inherit (console)
    version
    src
    ;

  minimalOCamlVersion = "5.4";

  nativeBuildInputs = [
    odoc
  ];

  propagatedBuildInputs = [
    console
    eio
    fmt
    mtime
    logs
  ];

  nativeCheckInputs = [
    k7
    (mdx.override { inherit logs; })
  ];

  checkInputs = [
    alcobar
    alcotest
    astring
    cmdliner
    matrix
    cstruct
    eio_main
    (jsont.override { withBytesrw = true; })
    bytesrw
    (mdx.override { inherit logs; })
  ];

  doCheck = true;

  meta = console.meta // {
    description = "Eio backend for console";
  };
}
