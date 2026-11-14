{
  buildDunePackage,
  raven,
  dune-configurator,
  pkg-config,
  openblas,
  zlib,
  windtrap,
  mdx,
  logs,
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
    openblas.dev
    zlib
  ];

  doCheck = true;

  nativeCheckInputs = [
    mdx.bin
    (mdx.override { inherit logs; })
  ];

  checkInputs = [
    windtrap
    mdx
  ];

  meta = raven.meta // {
    description = "High-performance N-dimensional array library for OCaml";
    longDescription = ''
      Nx is the core component of the Raven ecosystem providing efficient numerical computation with multi-device support.
      It offers NumPy-like functionality with the benefits of OCaml's type system.
    '';
  };
}
