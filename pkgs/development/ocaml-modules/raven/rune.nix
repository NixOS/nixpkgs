{
  buildDunePackage,
  dune-configurator,
  raven,
  raven-nx,
  pkg-config,
  libllvm,
  openblas,
  alcotest,
  camlzip,
  ctypes,
  ctypes-foreign,
  integers,
  mdx,
  stdlib-shims,
}:

buildDunePackage {
  pname = "rune";

  inherit (raven) version src sandboxProfile;

  patchPhase = ''
    substituteInPlace rune/vendor/llvm/config/discover.ml \
      --replace-fail \
        'let possible_names = [' \
        'let possible_names = [ "llvm-config";'
  '';

  nativeBuildInputs = [
    pkg-config
    libllvm
  ];

  buildInputs = [
    dune-configurator
    openblas.dev
  ];

  propagatedBuildInputs = [
    raven-nx
    ctypes
    ctypes-foreign
    integers
  ];

  doCheck = true;

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
