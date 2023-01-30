{ lib, stdenv, fetchFromGitHub, fetchpatch, makeFontsConf
, inkscape, xcursorgen, bc }:

stdenv.mkDerivation rec {
  pname = "graphite-cursors";
  version = "2021-11-26";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "sha256-Kopl2NweYrq9rhw+0EUMhY/pfGo4g387927TZAhI5/A=";
  };

  postPatch = ''
    patchShebangs .
  '';

  # Complains about not being able to find the fontconfig config file otherwise
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  buildInputs = [
    inkscape
    xcursorgen
    bc
  ];

  buildPhase = ''
    runHook preBuild
    for variant in dark dark-nord light light-nord; do
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/emojione/default.nix#L16
      HOME="$NIX_BUILD_ROOT" ./build.sh
    done
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -dm 0755 $out/share/icons
    cp -pr dist-dark $out/share/icons/graphite-cursors
    cp -pr dist-dark-nord $out/share/icons/graphite-cursors-nord
    cp -pr dist-light $out/share/icons/graphite-cursors-light
    cp -pr dist-light-nord $out/share/icons/graphite-cursors-light-nord
    runHook postInstall
  '';

  meta = with lib; {
    description = "Graphite cursors theme for linux desktops";
    homepage = "https://github.com/vinceliuice/Graphite-cursors";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
