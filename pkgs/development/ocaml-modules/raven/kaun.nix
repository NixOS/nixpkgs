{
  buildDunePackage,
  raven,
  bytesrw,
  jsont,
  raven-nx,
  raven-rune,
  windtrap,
  mdx,
  logs,
}:

buildDunePackage {
  pname = "kaun";

  inherit (raven) version src postUnpack;

  propagatedBuildInputs = [
    bytesrw
    jsont
    raven-nx
    raven-rune
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
    description = "Flax-inspired neural network library for OCaml";
    longDescription = ''
      Kaun brings modern deep learning to OCaml with a flexible,
      type-safe API for building and training neural networks.
      It leverages Rune for automatic differentiation and computation graph optimization
      while maintaining OCaml's functional programming advantages.
    '';
  };
}
