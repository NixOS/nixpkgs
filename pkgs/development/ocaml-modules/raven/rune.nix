{
  buildDunePackage,
  raven,
  lib,
  stdenv,
  dune-configurator,
  raven-nx,
  windtrap,
  mdx,
  logs,
}:

buildDunePackage {
  pname = "rune";

  inherit (raven) version src postUnpack;

  sandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
    (allow iokit-open)
    (allow file-read* (subpath "/System/Library/Extensions"))
    (allow mach-lookup (global-name "com.apple.MTLCompilerService"))
  '';

  buildInputs = [
    dune-configurator
  ];

  propagatedBuildInputs = [
    raven-nx
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
    description = "Automatic differentiation and JIT compilation for OCaml";
    longDescription = ''
      Rune provides automatic differentiation capabilities and
      experimental JIT compilation for the Raven ecosystem.
      It enables gradient-based optimization and supports
      functional transformations like grad, value_and_grad,
      and vmap, making it the foundation for deep learning in OCaml.
    '';
  };
}
