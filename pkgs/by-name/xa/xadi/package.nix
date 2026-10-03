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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "xtool-org";
    repo = "xadi";
    tag = "source-${finalAttrs.version}";
    hash = "sha256-cz0tQO68Q8YeublD6uJhx62YVms8kuA8Np4JZydpJLs=";
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
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # TODO: https://github.com/xtool-org/xadi/pull/3
    # use stdenv's deployment target, which ldc's runtime is built for
    substituteInPlace macOS/build.sh --replace-fail 'export MACOSX_DEPLOYMENT_TARGET=11.0' ""
    substituteInPlace macOS/build.sh --replace-fail /usr/bin/libtool libtool
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
