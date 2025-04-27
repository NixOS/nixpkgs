{
  lib,
  buildNpmPackage,
  electron_34,
  makeWrapper,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:
let
  pname = "vrcx";
  version = "2025.03.01";
  electron = electron_34;

  src = fetchFromGitHub {
    owner = "vrcx-team";
    repo = "VRCX";
    # v2025.03.01 tag is actually behind a few commits, namely the one that bumps the version (so it complains about not being up-to-date)
    #tag = "v${version}";
    rev = "1980eeb4cccebfcf33826d44b7833a9aa6f5a955";
    hash = "sha256-HiFcHnytynWYbeUd+KsG38dLU1FhDu0VD3JPT3kUO6s=";
  };

  backend = buildDotnetModule {
    inherit version src;
    pname = "${pname}-backend";

    nugetDeps = ./deps.json;
    dotnet-sdk = dotnetCorePackages.dotnet_9.sdk;
    dotnet-runtime = dotnetCorePackages.dotnet_9.runtime;
    projectFile = "Dotnet/VRCX-Electron.csproj";

    installPhase = ''
      runHook preInstall

      cp -r build/Electron $out

      runHook postInstall
    '';
  };
in
buildNpmPackage {
  inherit pname version src;

  npmDepsHash = "sha256-2ZU+9NPPx3GbU75XfjVroZCpjXr7IK2HtEIqLJLOjyw=";
  npmFlags = [ "--ignore-scripts" ];
  makeCacheWritable = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    env PLATFORM=linux npm exec webpack -- --config webpack.config.js --mode production
    node src-electron/patch-package-version.js
    npm exec electron-builder -- --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}
    node src-electron/patch-node-api-dotnet.js

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vrcx
    cp -r build/*-unpacked/resources "$out/lib/vrcx/"
    mkdir -p $out/lib/vrcx/resources/app.asar.unpacked/build
    cp -r ${backend} "$out/lib/vrcx/resources/app.asar.unpacked/build/Electron"

    makeWrapper '${electron}/bin/electron' "$out/bin/vrcx" \
      --add-flags "$out/lib/vrcx/resources/app.asar" \
      --set NODE_ENV production

    runHook postInstall
  '';

  passthru = {
    inherit backend;
  };

  meta = {
    description = "Friendship management tool for VRChat";
    longDescription = ''
      VRCX is an assistant/companion application for VRChat that provides information about and helps you accomplish various things
      related to VRChat in a more convenient fashion than relying on the plain VRChat client (desktop or VR), or website alone.
    '';
    license = lib.licenses.mit;
    homepage = "https://github.com/vrcx-team/VRCX";
    downloadPage = "https://github.com/vrcx-team/VRCX/releases";
    maintainers = with lib.maintainers; [
      ShyAssassin
      ImSapphire
    ];
    platforms = lib.platforms.linux;
  };
}
