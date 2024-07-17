{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  inkscape,
  python3Packages,
  xcursorgen,
}:
stdenvNoCC.mkDerivation {
  pname = "vimix-cursors";
  version = "2020-02-24-unstable-2021-09-18";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "vimix-cursors";
    rev = "9bc292f40904e0a33780eda5c5d92eb9a1154e9c";
    hash = "sha256-zW7nJjmB3e+tjEwgiCrdEe5yzJuGBNdefDdyWvgYIUU=";
  };

  nativeBuildInputs = [
    inkscape
    python3Packages.cairosvg
    xcursorgen
  ];

  postPatch = ''
    patchShebangs .
  '';

  buildPhase = ''
    runHook preBuild

    HOME="$NIX_BUILD_ROOT" ./build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -dm 755 $out/share/icons
    for color in "" "-white"; do
      cp -pr "dist$color/"  "$out/share/icons/Vimix$color-cursors"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "An X cursor theme inspired by Materia design";
    homepage = "https://github.com/vinceliuice/Vimix-cursors";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ambroisie ];
    platforms = platforms.linux;
  };
}
