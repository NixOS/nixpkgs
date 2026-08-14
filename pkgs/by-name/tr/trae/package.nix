{
  lib,
  stdenv,
  buildVscode,
  fetchurl,
  dpkg,
  undmg,
  bash,
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:

let
  inherit (stdenv) hostPlatform;
  finalCommandLineArgs = "--update=false " + commandLineArgs;

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
  inherit useVSCodeRipgrep;
  inherit (sourcesJson) version vscodeVersion;
  commandLineArgs = finalCommandLineArgs;

  pname = "trae";
  executableName = "trae";
  longName = "Trae";
  shortName = "trae";
  libraryName = "trae";
  iconName = "trae";

  src =
    if hostPlatform.isLinux then
      stdenv.mkDerivation {
        name = "${pname}-source-${version}";
        src = source;
        nativeBuildInputs = [ dpkg ];
        unpackPhase = ''
          dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
        '';
        installPhase = "mkdir -p $out && cp -r usr/share/trae/* $out";
      }
    else
      source;

  # unpack DMG
  extraNativeBuildInputs = lib.optionals hostPlatform.isDarwin [ undmg ];

  sourceExecutableName = "trae";

  sourceRoot = if hostPlatform.isLinux then "${pname}-source-${version}" else "Trae.app";

  updateScript = null;

  tests = { };

  # Editing the `trae` binary within the app bundle causes the bundle's signature
  # to be invalidated, which prevents launching starting with macOS Ventura, because Trae is notarized.
  # See https://eclecticlight.co/2022/06/17/app-security-changes-coming-in-ventura/ for more information.
  dontFixup = stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Adaptive AI-powered IDE by ByteDance featuring intelligent Builder";
    homepage = "https://www.trae.ai/";
    changelog = "https://www.trae.ai/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ goblinkingdev ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ]
    ++ lib.platforms.darwin;
    mainProgram = "trae";
  };
}).overrideAttrs
  (oldAttrs: {
    autoPatchelfIgnoreMissingDeps = (oldAttrs.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
      "libc.musl-x86_64.so.1"
    ];
    postPatch = ''
      target="resources/app/node_modules/@vscode/sudo-prompt/index.js"
      if [ -f "$target" ]; then
        substituteInPlace "$target" \
          --replace-fail "/usr/bin/pkexec" "/run/wrappers/bin/pkexec" \
          --replace-fail "/bin/bash" "${lib.getExe bash}"
      fi
    '';
    preFixup = (oldAttrs.preFixup or "") + ''
      find $out -name "*.musl.node" -delete
      find $out -name "*musl*" -type d -exec rm -rf {} +
    '';
  })
