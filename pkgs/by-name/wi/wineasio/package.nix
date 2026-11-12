{
  stdenv,
  lib,
  fetchFromGitHub,
  libjack2,
  pkg-config,
  wineWow64Packages,
  python3,
  python3Packages,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wineasio";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "wineasio";
    repo = "wineasio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yw07XBzllbZ7l1XZcCvEaxZieaHLVxM5cmBM+HAjtQ4=";
    fetchSubmodules = true;
  };

  wineasio-settings = python3Packages.buildPythonApplication {
    inherit (finalAttrs) src version;
    pname = "wineasio-settings";
    pyproject = false;

    sourceRoot = "${finalAttrs.src.name}/gui";

    postPatch = ''
      patchShebangs wineasio-settings
      substituteInPlace wineasio-settings \
        --replace-fail /usr/bin/python3 ${python3}/bin/python3
    '';

    nativeBuildInputs = [ qt6.wrapQtAppsHook ];
    buildInputs = [ qt6.qtbase ];
    dependencies = with python3Packages; [ pyqt6 ];

    makeFlags = [ "PREFIX=$(out)" ];

    dontWrapQtApps = true;
    dontWrapPythonPrograms = true;

    postFixup = ''
      wrapQtApp $out/bin/wineasio-settings \
        --prefix PYTHONPATH : "$PYTHONPATH"
    '';
  };

  nativeBuildInputs = [
    pkg-config
    wineWow64Packages.stable
  ];

  buildInputs = [
    libjack2
  ];

  dontConfigure = true;

  makeFlags = [ "PREFIX=${wineWow64Packages.stable}" ];

  buildPhase = ''
    runHook preBuild
    make "''${makeFlags[@]}" 64
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D build64/wineasio64.dll    $out/lib/wine/x86_64-windows/wineasio64.dll
    install -D build64/wineasio64.dll.so $out/lib/wine/x86_64-unix/wineasio64.dll.so

    mkdir -p $out/bin
    ln -s ${finalAttrs.wineasio-settings}/bin/wineasio-settings $out/bin/wineasio-settings

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/wineasio/wineasio";
    changelog = "https://github.com/wineasio/wineasio/releases/tag/${finalAttrs.src.tag}";
    description = "ASIO to JACK driver for WINE";
    license = with lib.licenses; [
      gpl2
      lgpl21
    ];
    maintainers = with lib.maintainers; [
      lovesegfault
      thunze
    ];
    platforms = [ "x86_64-linux" ];
  };
})
