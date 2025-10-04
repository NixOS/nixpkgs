{
  multiStdenv,
  lib,
  fetchFromGitHub,
  libjack2,
  pkg-config,
  wineWowPackages,
  pkgsi686Linux,
  python3,
  python3Packages,
  qt6,
}:

multiStdenv.mkDerivation rec {
  pname = "wineasio";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "wineasio";
    repo = "wineasio";
    tag = "v${version}";
    hash = "sha256-Yw07XBzllbZ7l1XZcCvEaxZieaHLVxM5cmBM+HAjtQ4=";
    fetchSubmodules = true;
  };

  wineasio-settings = python3Packages.buildPythonApplication {
    inherit src version;
    pname = "wineasio-settings";
    pyproject = false;

    sourceRoot = "${src.name}/gui";

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
    wineWowPackages.stable
  ];

  buildInputs = [
    pkgsi686Linux.libjack2
    libjack2
  ];

  dontConfigure = true;

  makeFlags = [ "PREFIX=${wineWowPackages.stable}" ];

  buildPhase = ''
    runHook preBuild
    make "''${makeFlags[@]}" 32
    make "''${makeFlags[@]}" 64
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D build32/wineasio32.dll    $out/lib/wine/i386-windows/wineasio32.dll
    install -D build32/wineasio32.dll.so $out/lib/wine/i386-unix/wineasio32.dll.so
    install -D build64/wineasio64.dll    $out/lib/wine/x86_64-windows/wineasio64.dll
    install -D build64/wineasio64.dll.so $out/lib/wine/x86_64-unix/wineasio64.dll.so

    mkdir -p $out/bin
    ln -s ${wineasio-settings}/bin/wineasio-settings $out/bin/wineasio-settings

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/wineasio/wineasio";
    changelog = "https://github.com/wineasio/wineasio/releases/tag/${src.tag}";
    description = "ASIO to JACK driver for WINE";
    license = with licenses; [
      gpl2
      lgpl21
    ];
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
  };
}
