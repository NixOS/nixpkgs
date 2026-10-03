{
  stdenvNoCC,
  python3,
  fetchFromGitHub,
  lib,
  makeWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xcode-build-server";
  version = "1.3.0";

  strictDeps = true;
  __structuredattrs = true;

  src = fetchFromGitHub {
    owner = "SolaWing";
    repo = "xcode-build-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AUGDoMeW/FSMJLG7uR580cMpytYQBFV2PXE3LBNaiFQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ (python3.withPackages (_: [ ])) ];

  dontPatchShebangs = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/xcode-build-server
    cp -r * $out/libexec/xcode-build-server

    # The main binary has a shebang that needs patching. Nothing else has a
    # shebang, except xcode/build.js, whose shebang has to remain as is (it
    # points to osascript, which can't be packaged in nix).
    patchShebangs --host $out/libexec/xcode-build-server/xcode-build-server

    makeWrapper $out/libexec/xcode-build-server/xcode-build-server $out/bin/xcode-build-server \
      --prefix PATH : ${lib.makeBinPath [ python3 ]}:/usr/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Build server protocol implementation for integrating Xcode with sourcekit-lsp";
    homepage = "https://github.com/SolaWing/xcode-build-server";
    license = licenses.mit;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ lylythechosenone ];
    mainProgram = "xcode-build-server";
  };
})
