{
  buildDunePackage,
  raven,
  alcotest,
  camlzip,
  ctypes,
  ctypes-foreign,
  dune-configurator,
  integers,
  mdx,
  stdlib-shims,
  pkg-config,
}:

buildDunePackage {
  pname = "nx";

  inherit (raven) version src sandboxProfile;

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
