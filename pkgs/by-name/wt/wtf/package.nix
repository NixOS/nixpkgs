{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wtf";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "0vercl0k";
    repo = "wtf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d2Gh70FG3maAZ9JV6AxH0Jkm5Eb2hONw5236AqPUBFY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  sourceRoot = "source/src";

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 wtf $out/bin/wtf

    runHook postInstall
  '';

  meta = {
    description = "Cross-platform snapshot-based fuzzer";
    homepage = "https://github.com/0vercl0k/wtf";
    changelog = "https://github.com/0vercl0k/wtf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ mikehorn ];
    mainProgram = "wtf";
  };
})
