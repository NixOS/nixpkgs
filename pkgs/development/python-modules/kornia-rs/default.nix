{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  cmake,
  nasm,
  libiconv,
}:

buildPythonPackage rec {
  pname = "kornia-rs";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kornia";
    repo = "kornia-rs";
    tag = "v${version}";
    hash = "sha256-0Id1Iyd/xyqSqFvg/TXnlX1DgMUWuMS9KbtDXduwU+Y=";
  };

  nativeBuildInputs = [
    rustPlatform.maturinBuildHook
    rustPlatform.cargoSetupHook
    cmake # Only for dependencies.
    nasm # Only for dependencies.
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  postUnpack = ''
    cp -v ${./Cargo.lock} source/${cargoRoot}/Cargo.lock
  '';

  cargoRoot = "kornia-py";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      postUnpack
      ;
    hash = "sha256-oihWdfCnWx7wpWwwl+FqPQAovIa3EIr4C8FgKj9tdq0=";
  };

  maturinBuildFlags = [
    "-m"
    "kornia-py/Cargo.toml"
  ];

  dontUseCmakeConfigure = true; # We only want to use CMake to build some Rust dependencies.

  meta = with lib; {
    homepage = "https://github.com/kornia/kornia-rs";
    description = "Python bindings to Low-level Computer Vision library in Rust";
    license = licenses.asl20;
    maintainers = with maintainers; [ chpatrick ];
  };
}
