{ stdenv, fetchFromGitHub
, inkscape, xcursorgen, bc }:

stdenv.mkDerivation rec {
  pname = "capitaine-cursors";
  version = "4";

  src = fetchFromGitHub {
    owner = "keeferrourke";
    repo = pname;
    rev = "r${version}";
    sha256 = "0652ydy73x29z7wc6ccyqihmfg4bk0ksl7yryycln6c7i0iqfmc9";
  };

  postPatch = ''
    patchShebangs .
  '';

  buildInputs  =[
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

  meta = with stdenv.lib; {
    description = ''
      An x-cursor theme inspired by macOS and based on KDE Breeze
    '';
    homepage = "https://github.com/keeferrourke/capitaine-cursors";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
