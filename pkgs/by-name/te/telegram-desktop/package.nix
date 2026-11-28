{
  callPackage,
  lib,
  stdenv,
  pname ? "telegram-desktop",
  unwrapped ? callPackage ./unwrapped.nix { inherit stdenv; },
  kdePackages,
  wrapGAppsHook3,
  geoclue2,
  glib-networking,
  webkitgtk_4_1,
  withWebkit ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  inherit (finalAttrs.unwrapped) version meta passthru;

  inherit unwrapped;

  nativeBuildInputs = [
    kdePackages.wrapQtAppsHook
  ]
  ++ lib.optionals withWebkit [
    wrapGAppsHook3
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtimageformats
    kdePackages.qtsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    kdePackages.kimageformats
    kdePackages.qtwayland
  ]
  ++ lib.optionals withWebkit [
    glib-networking
  ];

  qtWrapperArgs = lib.optionals (stdenv.hostPlatform.isLinux && withWebkit) [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [
      geoclue2
      webkitgtk_4_1
    ])
  ];

  dontUnpack = true;
  dontWrapGApps = true;
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall
    cp -r "$unwrapped" "$out"
    runHook postInstall
  '';

  preFixup = lib.optionalString (stdenv.hostPlatform.isLinux && withWebkit) ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      wrapQtApp "$out/Applications/${finalAttrs.meta.mainProgram}.app/Contents/MacOS/${finalAttrs.meta.mainProgram}"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace $out/share/dbus-1/services/* \
        --replace-fail "$unwrapped" "$out"
    '';
})
