{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchpatch,
  makeFontsConf,
  inkscape,
  xcursorgen,
  bc,
}:

stdenvNoCC.mkDerivation rec {
  pname = "capitaine-cursors";
  version = "4";

  src = fetchFromGitHub {
    owner = "keeferrourke";
    repo = pname;
    rev = "r${version}";
    sha256 = "0652ydy73x29z7wc6ccyqihmfg4bk0ksl7yryycln6c7i0iqfmc9";
  };

  patches = [
    # Fixes the build on inscape => 1.0, without this it generates empty cursor files
    (fetchpatch {
      name = "inkscape-1.0-compat";
      url = "https://github.com/keeferrourke/capitaine-cursors/commit/9da0b53e6098ed023c5c24c6ef6bfb1f68a79924.patch";
      sha256 = "0lx5i60ahy6a2pir4zzlqn5lqsv6claqg8mv17l1a028h9aha3cv";
    })
  ];

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
    for variant in dark light ; do
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/emojione/default.nix#L16
      HOME="$NIX_BUILD_ROOT" ./build.sh --max-dpi xhd --type $variant
    done
  '';

  installPhase = ''
    install -dm 0755 $out/share/icons
    cp -pr dist/dark $out/share/icons/capitaine-cursors
    cp -pr dist/light $out/share/icons/capitaine-cursors-white
  '';

  meta = with lib; {
    description = "An x-cursor theme inspired by macOS and based on KDE Breeze";
    homepage = "https://github.com/keeferrourke/capitaine-cursors";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eadwu ];
  };
}
