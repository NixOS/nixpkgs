{ stdenv, fetchFromGitHub
, inkscape, xcursorgen }:

stdenv.mkDerivation rec {
  pname = "capitaine-cursors";
  version = "3";

  src = fetchFromGitHub {
    owner = "keeferrourke";
    repo = pname;
    rev = "r${version}";
    sha256 = "0pnfbmrn9nv8pryv6cbjcq5hl9366hzvz1kd8vsdkgb2nlfv5gdv";
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
    cp -pr dist-white $out/share/icons/capitaine-cursors-white
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
