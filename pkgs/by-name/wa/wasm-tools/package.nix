{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
<<<<<<< HEAD
  version = "1.243.0";
=======
  version = "1.239.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-tools";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-wVIGwFWQvQvFl170I0VgYaTvaJnOGv6GrtM6VGpPxSc=";
=======
    hash = "sha256-XxP0T3nwhByG4wGknLVUCv38sUyFtEM7jrmVJlujohY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;

<<<<<<< HEAD
  cargoHash = "sha256-9BYethBg9seBOCCJTLYvAXDXj2dfjSZWPBOQS1TqD90=";
=======
  cargoHash = "sha256-xIfTYJMVP47timzquEYEb9M8BHsj83NjgD44lbzgd+Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cargoBuildFlags = [
    "--package"
    "wasm-tools"
  ];
  cargoTestFlags = [
<<<<<<< HEAD
    "--workspace"
    "--exclude"
    "wit-dylib"
=======
    "--all"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ]
  ++
    # Due to https://github.com/bytecodealliance/wasm-tools/issues/1820
    [
      "--"
      "--test-threads=1"
    ];

<<<<<<< HEAD
  meta = {
    description = "Low level tooling for WebAssembly in Rust";
    homepage = "https://github.com/bytecodealliance/wasm-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ereslibre ];
=======
  meta = with lib; {
    description = "Low level tooling for WebAssembly in Rust";
    homepage = "https://github.com/bytecodealliance/wasm-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "wasm-tools";
  };
}
