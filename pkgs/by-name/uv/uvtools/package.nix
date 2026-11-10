{
  lib,
  stdenv,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  emgucv,
  fontconfig,
  freetype,
  icu,
  krb5,
  openssl,
  zlib,
  lttng-ust_2_12,
  dbus,
  libGL,
  libx11,
  libice,
  libsm,
  libxcursor,
  libxext,
  libxi,
  libxrandr,
}:

buildDotnetModule (finalAttrs: {
  pname = "uvtools";
  version = "7.0.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "sn4k3";
    repo = "UVtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ViCOAgKHOCWSBhknXgPnJnL6rxqS7bM+7NB1Hshp9UQ=";
  };

  # UVtools.Core reaches OpenCV through Emgu.CV, whose native half upstream
  # vendors in build/platforms and also pulls in as Emgu.CV.runtime.mini.*
  # NuGet packages. Drop both and use the libcvextern.so built from source
  postPatch = ''
    # libcvextern.so and the managed Emgu.CV assembly have to come from the
    # same Emgu CV release to be compatible
    if ! grep -q 'Include="Emgu.CV" Version="${emgucv.version}\.' UVtools.Core/UVtools.Core.csproj; then
      echo "Emgu.CV does not match emgucv ${emgucv.version}; the emgucv package needs updating alongside this one." >&2
      exit 1
    fi

    find build/platforms '(' -name 'libcvextern.*' -o -name 'cvextern.dll' ')' -delete
    install -Dm444 ${lib.getLib emgucv}/lib/libcvextern.so \
      build/platforms/${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system}/libcvextern.so

    sed -i '/Emgu\.CV\.runtime\.mini/d' UVtools.Core/UVtools.Core.csproj
  '';

  projectFile = [
    "UVtools.UI/UVtools.UI.csproj"
    "UVtools.Cmd/UVtools.Cmd.csproj"
  ];
  nugetDeps = ./deps.json;

  doCheck = true;
  testProjectFile = "tests/UVtools.Tests/UVtools.Tests.csproj";

  dotnet-sdk =
    with dotnetCorePackages;
    sdk_10_0
    // {
      inherit
        (combinePackages [
          sdk_10_0
          sdk_9_0
          sdk_8_0
        ])
        packages
        targetPackages
        ;
    };
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  executables = [
    "UVtools"
    "UVtoolsCmd"
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    fontconfig
    freetype
    icu
    krb5
    openssl
    zlib
    lttng-ust_2_12
    (lib.getLib stdenv.cc.cc)
  ];

  runtimeDeps = [
    # Avalonia X11 backend
    fontconfig
    libice
    libsm
    libx11
    libxcursor
    libxext
    libxi
    libxrandr
    # GPU-accelerated 3D viewer; dlopens libGL.so.1 and libEGL.so.1
    libGL
    # FreeDesktop integration: portals, file dialogs, theme detection
    dbus
  ];

  postInstall = ''
    install -Dm444 UVtools.CAD/UVtools.svg \
      $out/share/icons/hicolor/scalable/apps/uvtools.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "uvtools";
      desktopName = "UVtools";
      comment = "MSLA/DLP file analysis, calibration, repair and conversion";
      exec = "UVtools %f";
      icon = "uvtools";
      categories = [
        "Graphics"
        "3DGraphics"
        "Engineering"
      ];
    })
  ];

  # meta.mainProgram is the GUI, which needs a display; check the CLI instead.
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/UVtoolsCmd";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MSLA/DLP file analysis, calibration, repair and conversion tool";
    homepage = "https://github.com/sn4k3/UVtools";
    changelog = "https://github.com/sn4k3/UVtools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Plus;
    mainProgram = "UVtools";
    maintainers = with lib.maintainers; [ kanagawamarcos ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
