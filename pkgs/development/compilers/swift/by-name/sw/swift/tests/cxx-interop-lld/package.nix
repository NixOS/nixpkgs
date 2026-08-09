{
  llvmPackages,
  stdenv,
  swift,
  swiftpm,
}:

stdenv.mkDerivation {
  name = "swift-test-cxx-interop-lld";

  src = ./src;

  strictDeps = true;

  env.NIX_CFLAGS_LINK = "-fuse-ld=lld";

  nativeBuildInputs = [
    swift
    swiftpm
    llvmPackages.lld
  ];

  installPhase = ''
    swift run -c release Repro | grep 11
    touch "$out"
  '';

  __structuredAttrs = true;
}
