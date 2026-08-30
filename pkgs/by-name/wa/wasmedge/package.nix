{
  lib,
  boost,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  libffi,
  libxml2,
  llvmPackages,
  spdlog,
  testers,
  nix-update-script,
}:

let
  stdenv = llvmPackages.stdenv;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wasmedge";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "WasmEdge";
    repo = "WasmEdge";
    tag = finalAttrs.version;
    hash = "sha256-+Z9mhIoRc8iJoCPafbkX3lB9nQAysKB5gjLmq8AUk/I=";
  };

  strictDeps = true;
  __structuredAttrs = true;

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
    llvmPackages.bintools
  ];

  buildInputs = [
    boost
    libffi
    libxml2
    llvmPackages.lld
    llvmPackages.llvm
    spdlog
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-DWASMEDGE_FORCE_DISABLE_LTO=ON"
  ];

  postPatch = ''
    echo -n $version > VERSION
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://wasmedge.org/";
    description = "Lightweight, high-performance, and extensible WebAssembly runtime for cloud native, edge, and decentralized applications";
    changelog = "https://github.com/WasmEdge/WasmEdge/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ilkecan ];
    platforms = lib.platforms.all;
  };
})
