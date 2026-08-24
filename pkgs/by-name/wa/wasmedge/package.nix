{
  lib,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "WasmEdge";
    repo = "WasmEdge";
    rev = finalAttrs.version;
    hash = "sha256-+Z9mhIoRc8iJoCPafbkX3lB9nQAysKB5gjLmq8AUk/I=";
  };

  patches = [
    # fmt 12.2's uint128 fallback does not support unary complement. PR #4936
    # was merged into WasmEdge's main development history on June 5, but the
    # 0.17.1 release was cut from a separate release line that diverged from
    # that history on May 18. The fix was not cherry-picked into that release
    # line.
    (fetchpatch {
      url = "https://github.com/WasmEdge/WasmEdge/commit/41a01b6b4f40defbac0dd551663c542cdcf9ae76.patch";
      hash = "sha256-g8EOz/dldPN7oM9+IKfwGCqMQgD8FnsT2w2WsyLdR60=";
    })
  ];

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
    license = lib.licenses.asl20;
    description = "Lightweight, high-performance, and extensible WebAssembly runtime for cloud native, edge, and decentralized applications";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
