{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,

  # buildInputs
  SDL2,
  libcxx,
  openal,

  # nativeBuildInputs
  cmake,
  git,
  pkg-config,
  imagemagick,
  libicns,
  copyDesktopItems,

  makeDesktopItem,

  # passthru
  callPackage,
  symlinkJoin,
  rsync,

  appName,
  CMAKE_BUILD_TYPE ? "RelWithDebInfo", # "Choose the type of build, recommended options are: Debug Release RelWithDebInfo"
}:
assert lib.assertOneOf "appName" appName [
  "vanillatd"
  "vanillara"
];
stdenv.mkDerivation (finalAttrs: {
  pname = appName;
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "TheAssemblyArmada";
    repo = "Vanilla-Conquer";
    # FIXME: This version has format-security
    rev = "ebc8083d5d149f98abc20f460a512a2d16fdc59f";
    hash = "sha256-iUF9UFc0FMvOwLkGqSyLYGy5E8YqNySqDp5VVUa+u4o=";
  };
  # TODO: Remove this. Just add this flag to ignore the format-security error temporarily.
  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  buildInputs = [
    SDL2
    libcxx
    openal
  ];

  nativeBuildInputs = [
    cmake
    git
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    imagemagick
    libicns
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_VANILLATD" (appName == "vanillatd"))
    (lib.cmakeBool "BUILD_VANILLARA" (appName == "vanillara"))
    (lib.cmakeBool "BUILD_REMASTERTD" (appName == "remastertd"))
    (lib.cmakeBool "BUILD_REMASTERRA" (appName == "remasterra"))
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" CMAKE_BUILD_TYPE)
  ];

  # TODO: Fix this from the upstream
  # remove the old FindSDL2.cmake logic, use cmake's built-in SDL2 support
  # replace ${SDL2_LIBRARY} to SDL2::SDL2 in CMakeLists.txt
  preConfigure = ''
    rm cmake/FindSDL2.cmake
    sed -i 's/..SDL2_LIBRARY./SDL2::SDL2/g' CMakeLists.txt
  '';

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/Applications
        mv ${appName}.app $out/Applications

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p $out/bin
        mv ${appName} $out/bin/${appName}
        install -Dm644 ../resources/${appName}_icon.svg $out/share/icons/hicolor/scalable/apps/${appName}.svg

        runHook postInstall
      '';

  desktopItems = [
    (makeDesktopItem {
      name = appName;
      desktopName = appName;
      comment =
        {
          "vanillatd" = "Command & Conquer: Tiberian Dawn";
          "vanillara" = "Command & Conquer: Red Alert";
        }
        ."${appName}";
      exec = appName;
      terminal = false;
      icon = appName;
      startupWMClass = appName;
      categories = [ "Game" ];
    })
  ];

  passthru =
    let
      packages = callPackage ./passthru-packages.nix { inherit appName; };
    in
    {
      inherit packages;

      withPackages =
        cb:
        let
          dataDerivation = symlinkJoin {
            name = "${appName}-data";
            paths = if builtins.isFunction cb then cb packages else cb;
          };
        in
        stdenvNoCC.mkDerivation {
          pname = "${appName}-with-packages";
          inherit (finalAttrs.finalPackage) version meta;

          buildInputs = [ dataDerivation ] ++ finalAttrs.buildInputs;
          nativeBuildInputs = [ rsync ];

          buildCommand =
            let
              Default_Data_Path =
                if stdenv.hostPlatform.isDarwin then
                  "$out/Applications/${appName}.app/Contents/share/${appName}"
                else
                  "$out/share/${appName}";
            in
            ''
              # The default Data_Path() is rely on the Program_Path(), which is the real path of executable, so we need to make executable non symlink here.
              rsync --archive --mkpath --chmod=a+w ${finalAttrs.finalPackage}/ $out/

              # Symlink the data derivation to the default data path
              mkdir -p ${dirOf Default_Data_Path}
              ln -s ${dataDerivation} ${Default_Data_Path}

              # Fix `error: suspicious ownership or permission on '/nix/store/xxx-0.0.0' for output 'out'; rejecting this build output`
              chmod 755 $out
            '';
        };
    };

  meta = {
    description =
      {
        "vanillatd" =
          "Vanilla Conquer is a modern, multi-platform source port of Command & Conquer: Tiberian Dawn";
        "vanillara" =
          "Vanilla Conquer is a modern, multi-platform source port of Command & Conquer: Red Alert";
      }
      ."${appName}";
    homepage = "https://github.com/TheAssemblyArmada/Vanilla-Conquer";
    license = with lib.licenses; [ gpl3Only ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    platforms = with lib.platforms; darwin ++ linux;
  };
})
