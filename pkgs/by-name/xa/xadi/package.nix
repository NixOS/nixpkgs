{
  lib,
  stdenv,
  buildDubPackage,
  cctools,
  fetchFromGitHub,
  xtool,
}:

let
  buildScript = if stdenv.hostPlatform.isDarwin then "macOS/build.sh" else "Linux/build.sh";
in
buildDubPackage (finalAttrs: {
  pname = "xadi";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "xtool-org";
    repo = "xadi";
    tag = "source-${finalAttrs.version}";
    hash = "sha256-AxdZOomfdiW9gQmd3vUVuOzytEwvNkeU30a2MVQUdGc=";
  };

  dubLock = ./dub-lock.json;

  # build only arm64 instead of a universal library
  patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./darwin-arm64-only.patch ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ cctools.libtool ];

  postPatch = ''
    # use the dependencies from dub-lock.json
    substituteInPlace ${buildScript} \
      --replace-fail 'dub build \' 'dub build --skip-registry=all \'

    # info.json version defaults to 0.0.1
    substituteInPlace ${buildScript} \
      --replace-fail '/update-info.sh "$bundle"' '/update-info.sh "$bundle" ${finalAttrs.version}'

    patchShebangs ${dirOf buildScript} ArtifactBundle
  '';

  buildPhase = ''
    runHook preBuild
    ./${buildScript}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    cp -r out/XADIBinary.artifactbundle $out/lib/
    runHook postInstall
  '';

  meta = {
    description = "CoreADI wrapper based on libprovision";
    homepage = "https://github.com/xtool-org/xadi";
    license = lib.licenses.lgpl21Only;
    inherit (xtool.meta) maintainers;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
