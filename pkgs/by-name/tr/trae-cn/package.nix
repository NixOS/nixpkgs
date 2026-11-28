{
  lib,
  stdenv,
  buildVscode,
  fetchurl,
  dpkg,
  curl,
  openssl,
  undmg,
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:

let
  inherit (stdenv) hostPlatform;

  sourcesJson = lib.importJSON ./sources.json;
  sources = lib.mapAttrs (
    _: info:
    fetchurl {
      inherit (info) url hash;
    }
  ) sourcesJson.sources;

  source = sources.${hostPlatform.system};
in
(buildVscode rec {
  inherit commandLineArgs useVSCodeRipgrep;
  inherit (sourcesJson) version vscodeVersion;

  pname = "trae-cn";

  executableName = "trae-cn";
  longName = "Trae CN";
  shortName = "trae-cn";
  libraryName = "trae-cn";
  iconName = "trae-cn";

  src =
    if hostPlatform.isLinux then
      stdenv.mkDerivation {
        name = "${pname}-source-${version}";
        src = source;
        nativeBuildInputs = [ dpkg ];
        unpackPhase = ''
          dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
        '';
        installPhase = "mkdir -p $out && cp -r usr/share/trae-cn/* $out";
      }
    else
      source;

  extraNativeBuildInputs = lib.optionals hostPlatform.isDarwin [ undmg ];

  sourceExecutableName = "trae-cn";
  sourceRoot = if hostPlatform.isLinux then "${pname}-source-${version}" else "Trae CN.app";

  dontFixup = hostPlatform.isDarwin;

  tests = { };
  updateScript = ./update.sh;

  meta = {
    description = "AI-powered IDE by ByteDance, The Real AI Engine";
    longDescription = ''
      Trae CN is an AI-powered integrated development environment by ByteDance
      that provides intelligent code completion, code generation, and AI-assisted
      development features. Built on Electron/Chromium (based on VS Code ${vscodeVersion}),
      it offers a modern development experience with advanced AI capabilities tailored
      for the Chinese market.
    '';
    homepage = "https://www.trae.ai/";
    changelog = "https://www.trae.ai/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ yjymosheng ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    mainProgram = "trae-cn";
  };
}).overrideAttrs
  (oldAttrs: {
    strictDeps = true;
    __structuredAttrs = true;

    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
      curl
      openssl
    ];

    autoPatchelfIgnoreMissingDeps = (oldAttrs.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
      "libc.musl-x86_64.so.1"
      "libsoup-3.0.so.0"
    ];

    preFixup = (oldAttrs.preFixup or "") + ''
      find $out -name "*.musl.node" -delete
      find $out -name "*musl*" -type d -exec rm -rf {} +
    '';
  })
