{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tantivy-go";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "tantivy-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ksHw+62JwQrzxLuXwYfTLOkC22Miz1Rpl5XX8+vPBcM=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust";

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
