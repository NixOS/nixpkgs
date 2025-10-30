{
  buildDunePackage,
  alcotest,
  camlzip,
  ctypes,
  ctypes-foreign,
  dune-configurator,
  integers,
  mdx,
  openblas,
  pkg-config,
  raven,
  stdlib-shims,
}:

buildDunePackage {
  pname = "nx";

  inherit (raven) version src postUnpack;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    camlzip
    ctypes
    ctypes-foreign
    integers
    mdx
    openblas.dev
    stdlib-shims
  ];

  doCheck = true;

  nativeCheckInputs = [
    mdx.bin
  ];

  checkInputs = [
    alcotest
  ];

  meta = raven.meta // {
    description = "High-performance N-dimensional array library for OCaml";
    longDescription = ''
      Nx is the core component of the Raven ecosystem providing efficient numerical computation with multi-device support.
      It offers NumPy-like functionality with the benefits of OCaml's type system.
    '';
  };
}
