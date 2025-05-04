{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "warpsharp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "IFeelBloated";
    repo = "warpsharp";
    rev = "refs/tags/r${lib.versions.major finalAttrs.version}";
    hash = "sha256-ar3Dg7SpW42AEZy3H9lnj9oNQO70e6M/s+TDvcofFCg=";
  };

  buildPhase = ''
    runHook preBuild

    $CXX -shared -o warpsharp.so -iquote . Source.cpp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 warpsharp.so -t $out/lib/

    runHook postInstall
  '';

  meta = {
    description = "fp32 warpsharp for vaporsynth";
    homepage = "https://github.com/IFeelBloated/warpsharp";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.unfree;
  };
})
