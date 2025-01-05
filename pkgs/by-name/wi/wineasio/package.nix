{
  multiStdenv,
  lib,
  fetchFromGitHub,
  libjack2,
  pkg-config,
  wineWowPackages,
  pkgsi686Linux,
}:

multiStdenv.mkDerivation rec {
  pname = "wineasio";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-d5BGJAkaM5XZXyqm6K/UzFE4sD6QVHHGnLi1bcHxiaM=";
    fetchSubmodules = true;
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
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/wineasio/wineasio";
    description = "ASIO to JACK driver for WINE";
    license = with licenses; [
      gpl2
      lgpl21
    ];
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
  };
}
