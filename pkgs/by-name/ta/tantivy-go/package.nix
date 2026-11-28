{
  lib,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  zstd,
  llvmPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tantivy-go";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "tantivy-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-59RzOEC2bKDJSCvoRxRd1QNVRlHboewlO8ifAiVDqME=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust";

  nativeBuildInputs = [
    pkg-config
    llvmPackages.llvm
  ];

  buildInputs = [ zstd ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rust-stemmers-1.2.0" = "sha256-GJYFQf025U42rJEoI9eIi3xDdK6enptAr3jphuKJdiw=";
      "tantivy-0.23.0" = "sha256-e2ffM2gRC5eww3xv9izLqukGUgduCt2u7jsqTDX5l8k=";
      "tantivy-jieba-0.11.0" = "sha256-BDz6+EVksgLkOj/8XXxPMVshI0X1+oLt6alDLMpnLZc=";
    };
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
    chmod +w ../bindings.h
  '';

  # Removes LLVM sections rejected by go linker in dependent packages (anytype-heart)
  # github.com/anyproto/anytype-heart/pkg/lib/localstore/ftsearch: disallowed LTO section ".llvmbc" in #cgo LDFLAGS: /build/source/deps/libs/linux-arm64-musl/libtantivy_go.a
  postInstall = ''
    llvm-objcopy --remove-section=.llvmbc --remove-section=.llvmcmd $out/lib/libtantivy_go.a
  '';

  meta = {
    description = "Tantivy go bindings";
    homepage = "https://github.com/anyproto/tantivy-go";
    changelog = "https://github.com/anyproto/tantivy-go/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      autrimpo
      adda
      kira-bruneau
    ];
  };
})
