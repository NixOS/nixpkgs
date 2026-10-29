{
  lib,
  fetchFromGitHub,
  llvmPackages_19,
  boost,
  cmake,
  spdlog,
  libxml2,
  libffi,
  testers,
}:

let
  # The supported version is found in the changelog, the documentation does indicate a minimum version but not a maximum.
  # The project is also using a `flake.nix` so we can retrieve the used llvm version with:
  #
  # ```shell
  # nix eval --inputs-from .# nixpkgs#llvmPackages.libllvm.version
  # ```
  #
  # > Where `.#` is the flake path were the repo `wasmedge` was cloned at the expected version.
  llvmPackages = llvmPackages_19;
  stdenv = llvmPackages.stdenv;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wasmedge";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "WasmEdge";
    repo = "WasmEdge";
    rev = finalAttrs.version;
    sha256 = "sha256-Z6SnTKLW1nBa9gCSDO3d+CmwfWpGRAb2D9ZCoqqqMjk=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages.lld
  ];

  buildInputs = [
    boost
    spdlog
    llvmPackages.llvm
    libxml2
    libffi
  ];

  cmakeFlags = [
    "-DWASMEDGE_BUILD_TESTS=OFF" # Tests are downloaded using git
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DWASMEDGE_FORCE_DISABLE_LTO=ON"
  ];

  postPatch = ''
    echo -n $version > VERSION
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://wasmedge.org/";
    license = with lib.licenses; [ asl20 ];
    description = "Lightweight, high-performance, and extensible WebAssembly runtime for cloud native, edge, and decentralized applications";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
