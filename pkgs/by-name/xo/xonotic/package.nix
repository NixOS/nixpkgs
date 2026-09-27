{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchzip,
  copyDesktopItems,
  makeBinaryWrapper,
  makeDesktopItem,
  xonotic-darkplaces,

  withSDL ? true,
  withGLX ? false,
  withDedicated ? true,
}:

assert lib.assertMsg (
  withSDL || withGLX || withDedicated
) "xonotic: at least one of withSDL, withGLX or withDedicated needs to be enabled";

let
  inherit (stdenv.hostPlatform) isLinux isDarwin;

  version = "0.8.6";

  graphical = withSDL || withGLX;

  engines =
    lib.optional withSDL "sdl" ++ lib.optional withGLX "glx" ++ lib.optional withDedicated "dedicated";

  # The default SDL build keeps the canonical name.
  variant =
    let
      engine = lib.head engines;
    in
    if engine == "sdl" then "" else "-${engine}";

  mainSrc = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "xonotic";
    repo = "xonotic";
    tag = "xonotic-v${version}";
    hash = "sha256-V4x30GaTRM7GbYtg+oJdPNSrtnxYc3dH/bBcv4ZYkys=";
  };

  data = fetchzip {
    name = "xonotic-data-${version}";
    url = "https://dl.xonotic.org/xonotic-${version}.zip";
    hash = "sha256-Lhjpyk7idmfQAVn4YUb7diGyyKZQBfwNXxk2zMOqiZQ=";
    postFetch = ''
      cd $out
      shopt -s extglob
      rm -rf !(data|key_0.d0pk)
    '';
    meta = {
      description = "Game data for Xonotic";
      license = lib.licenses.gpl2Plus;
      hydraPlatforms = lib.platforms.none;
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xonotic${variant}";
  inherit version;

  src = mainSrc;

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals (isLinux && graphical) [ copyDesktopItems ];

  desktopItems = lib.optionals (isLinux && graphical) [
    (makeDesktopItem {
      name = "xonotic";
      exec = "xonotic";
      comment = finalAttrs.meta.description;
      desktopName = "Xonotic";
      categories = [
        "Game"
        "Shooter"
      ];
      icon = "xonotic";
      startupNotify = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 misc/logos/xonotic_icon.svg \
      $out/share/icons/hicolor/scalable/apps/xonotic.svg

    pushd misc/logos/icons_png
      for img in *.png; do
        size=''${img#xonotic_}
        size=''${size%.png}
        install -Dm644 "$img" \
          "$out/share/icons/hicolor/''${size}x''${size}/apps/xonotic.png"
      done
    popd
  ''
  + lib.concatMapStringsSep "\n" (engine: ''
    install -Dm755 ${lib.getExe' xonotic-darkplaces "darkplaces-${engine}"} "$out/bin/xonotic-${engine}"
  '') engines
  + lib.optionalString graphical ''
    ln -s xonotic-${if withSDL then "sdl" else "glx"} "$out/bin/xonotic"
  ''
  + lib.optionalString (isDarwin && withSDL) ''
    install -Dm644 misc/buildfiles/osx/Xonotic.app/Contents/Info.plist \
      "$out/Applications/Xonotic.app/Contents/Info.plist"
    install -Dm644 misc/buildfiles/osx/Xonotic.app/Contents/Resources/Xonotic.icns \
      "$out/Applications/Xonotic.app/Contents/Resources/Xonotic.icns"
    makeBinaryWrapper "$out/bin/xonotic-sdl" \
      "$out/Applications/Xonotic.app/Contents/MacOS/xonotic-osx-sdl"
  ''
  + ''
    runHook postInstall
  '';

  postFixup = ''
    for bin in ${lib.escapeShellArgs (map (engine: "xonotic-${engine}") engines)}; do
      wrapProgram "$out/bin/$bin" --add-flags "-basedir ${data}"
    done
  '';

  passthru = {
    inherit data;
  };

  meta = {
    description = "Free fast-paced first-person shooter";
    longDescription = ''
      Xonotic is a free, fast-paced first-person shooter that works on
      Windows, macOS and Linux. The project is geared towards providing
      addictive arena shooter gameplay which is all spawned and driven
      by the community itself. Xonotic is a direct successor of the
      Nexuiz project with years of development between them, and it
      aims to become the best possible open-source FPS of its kind.
    '';
    homepage = "https://www.xonotic.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      zalakain
      philocalyst
    ];
    platforms = if withGLX then lib.platforms.linux else lib.platforms.linux ++ lib.platforms.darwin;
    hydraPlatforms = lib.platforms.none;
    mainProgram = "xonotic${variant}";
  };
})
