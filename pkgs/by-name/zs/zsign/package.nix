{
  lib,
  fetchFromGitHub,
  stdenv,
  openssl,
  pkg-config,
  minizip,
  nix-update-script,
  zlib,
  versionCheckHook,
}:
let
  platformName = if stdenv.hostPlatform.isLinux then "linux" else "macos";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zsign";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "zhlynn";
    repo = "zsign";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e4k3W+FkdydqPy3DuhH6MbC+IilLZfqOb7FAbIiv/kM=";
  };

  postPatch = ''
    substituteInPlace ../../src/common/archive.cpp \
      --replace-fail "#include <zip.h>" "#include <minizip/zip.h>" \
      --replace-fail "#include <unzip.h>" "#include <minizip/unzip.h>"
  '';

  sourceRoot = "${finalAttrs.src.name}/build/${platformName}";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    minizip
    zlib
  ];

  makeFlags = [
    "BINDIR=bin/"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    cp bin/zsign $out/bin/

    runHook postInstall
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform codesign alternative for iOS 12+";
    homepage = "https://github.com/zhlynn/zsign";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pascalj ];
    mainProgram = "zsign";
    platforms = with lib.platforms; darwin ++ linux;
  };
})
