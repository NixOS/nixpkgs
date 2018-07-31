{ stdenv, fetchFromGitHub
, inkscape, xcursorgen }:

stdenv.mkDerivation rec {
  name = "capitaine-cursors-${version}";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "keeferrourke";
    repo = "capitaine-cursors";
    rev = "r${version}";
    sha256 = "0ljvq1dqscp5gyf23qszn2ax80bxkqw2vx5zh3qln9vnzfascirb";
  };

  postPatch = ''
    patchShebangs .
  '';

  buildInputs  =[
    inkscape
    xcursorgen
  ];

  buildPhase = ''
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/emojione/default.nix#L16
    HOME="$NIX_BUILD_ROOT" ./build.sh
  '';

  installPhase = ''
    install -dm 0755 $out/share/icons
    cp -pr dist $out/share/icons/capitaine-cursors
  '';

  meta = with stdenv.lib; {
    description = ''
      An x-cursor theme inspired by macOS and based on KDE Breeze
    '';
    homepage = https://github.com/keeferrourke/capitaine-cursors;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
