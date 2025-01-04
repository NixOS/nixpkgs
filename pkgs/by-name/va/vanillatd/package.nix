{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  cmake,
  pkg-config,
  git,
  libcxx,
  SDL2,
  openal,
  imagemagick,
  libicns,
  symlinkJoin,
  unar,
  rsync,
  makeDesktopItem,
  copyDesktopItems,
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
    libcxx
    SDL2
    openal
  ];
  nativeBuildInputs =
    [
      cmake
      pkg-config
      git
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libicns
      imagemagick
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      copyDesktopItems
    ];

  cmakeFlags = [
    (lib.cmakeFeature "BUILD_VANILLATD" (if appName == "vanillatd" then "ON" else "OFF"))
    (lib.cmakeFeature "BUILD_VANILLARA" (if appName == "vanillara" then "ON" else "OFF"))
    (lib.cmakeFeature "BUILD_REMASTERTD" (if appName == "remastertd" then "ON" else "OFF"))
    (lib.cmakeFeature "BUILD_REMASTERRA" (if appName == "remasterra" then "ON" else "OFF"))
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
    if stdenv.isDarwin then
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
  passthru = rec {
    packages =
      builtins.mapAttrs
        (
          name: buildPhase:
          stdenvNoCC.mkDerivation {
            inherit name buildPhase;
            phases = [ "buildPhase" ];
            nativeBuildInputs = [ unar ];
            meta = {
              sourceProvenance = with lib.sourceTypes; [
                binaryBytecode
              ];
              license = with lib.licenses; [
                unfree
              ];
            };
          }
        )
        (
          if appName == "vanillatd" then
            let
              CCDEMO1_ZIP = fetchurl {
                url = "https://archive.org/download/CommandConquerDemo/cc1demo1.zip";
                hash = "sha256-KdM4SctFCocmJCbMWbJbql4DO5TC40leyU+BPzvAn4c=";
              };
              CCDEMO2_ZIP = fetchurl {
                url = "https://archive.org/download/CommandConquerDemo/cc1demo2.zip";
                hash = "sha256-pCgEuE5AFcJur3qUOTmP3GCb/Wp7p7JyVn8Yeq17PEg=";
              };
              demo = ''
                unar -no-directory ${CCDEMO1_ZIP} DEMO.MIX DEMOL.MIX SOUNDS.MIX SPEECH.MIX
                unar -no-directory ${CCDEMO2_ZIP} DEMOM.MIX
                mkdir -p $out
                mv DEMO.MIX $out/demo.mix
                mv DEMOL.MIX $out/demol.mix
                mv SOUNDS.MIX $out/sounds.mix
                mv SPEECH.MIX $out/speech.mix
                mv DEMOM.MIX $out/demom.mix
              '';
            in
            # see https://github.com/TheAssemblyArmada/Vanilla-Conquer/wiki/Installing-VanillaTD
            {
              inherit demo;
            }
          else if appName == "vanillara" then
            let
              RA95DEMO_ZIP = fetchurl {
                url = "https://archive.org/download/CommandConquerRedAlert_1020/ra95demo.zip";
                hash = "sha256-jEi9tTUj6k01OnkU2SNM5OPm9YMu60eztrAFhT6HSNI=";
              };
              demo = ''
                unar -no-directory ${RA95DEMO_ZIP} ra95demo/INSTALL/MAIN.MIX ra95demo/INSTALL/REDALERT.MIX
                install -D ra95demo/INSTALL/REDALERT.MIX $out/redalert.mix
                install -D ra95demo/INSTALL/MAIN.MIX $out/main.mix
              '';
              REDALERT_ALLIED_ISO = fetchurl {
                url = "https://archive.org/download/cnc-red-alert/redalert_allied.iso";
                hash = "sha256-Npx6hSTJetFlcb/Fi3UQEGuP0iLk9LIrRmAI7WgEtdw=";
              };
              REDALERT_SOVIETS_ISO = fetchurl {
                url = "https://archive.org/download/cnc-red-alert/redalert_soviets.iso";
                hash = "sha256-aJGr+w1BaGaLwX/pU0lMmu6Cgn9pZ2D/aVafBdtds2Q=";
              };
              retail-allied = ''
                unar -output-directory allied -no-directory ${REDALERT_ALLIED_ISO} MAIN.MIX INSTALL/REDALERT.MIX
                mkdir -p $out/allied/
                mv allied/INSTALL/REDALERT.MIX $out/redalert.mix
                mv allied/MAIN.MIX $out/allied/main.mix
              '';
              retail-soviet = ''
                unar -output-directory soviet -no-directory ${REDALERT_SOVIETS_ISO} MAIN.MIX INSTALL/REDALERT.MIX
                mkdir -p $out/soviet/
                mv soviet/INSTALL/REDALERT.MIX $out/redalert.mix
                mv soviet/MAIN.MIX $out/soviet/main.mix
              '';
              retail = ''
                unar -output-directory allied -no-directory ${REDALERT_ALLIED_ISO} MAIN.MIX INSTALL/REDALERT.MIX
                unar -output-directory soviet -no-directory ${REDALERT_SOVIETS_ISO} MAIN.MIX
                mkdir -p $out/allied/ $out/soviet/
                mv allied/INSTALL/REDALERT.MIX $out/redalert.mix
                mv allied/MAIN.MIX $out/allied/main.mix
                mv soviet/MAIN.MIX $out/soviet/main.mix
              '';
            in
            # see https://github.com/TheAssemblyArmada/Vanilla-Conquer/wiki/Installing-VanillaRA
            {
              inherit
                demo
                retail-allied
                retail-soviet
                retail
                ;
            }
          else
            { }
        );
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

        phases = [ "buildPhase" ];
        buildPhase =
          let
            Default_Data_Path =
              if stdenv.isDarwin then
                "$out/Applications/${appName}.app/Contents/share/${appName}"
              else
                "$out/share/${appName}";
          in
          ''
            # The default Data_Path() is rely on the Program_Path(), which is the real path of executable, so we need to make executable non symlink here.
            rsync --archive --mkpath --chmod=a+w ${finalAttrs.finalPackage}/ $out/

            # Symlink the data derivation to the default data path
            mkdir -p ${builtins.dirOf Default_Data_Path}
            ln -s ${dataDerivation} ${Default_Data_Path}

            # Fix `error: suspicious ownership or permission on '/nix/store/xxx-0.0.0' for output 'out'; rejecting this build output`
            chmod 755 $out
          '';
      };
  };
})
