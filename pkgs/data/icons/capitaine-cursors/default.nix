{ stdenv, fetchFromGitHub
, bc, inkscape, xcursorgen }:

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

  buildInputs = [
    bc
    inkscape
    xcursorgen
  ];

  buildPhase = ''
    # Shut up inkscape's warnings
    export HOME="$NIX_BUILD_ROOT"

    ./build.sh --max-dpi xxxhd --type dark --platform unix
    ./build.sh --max-dpi xxxhd --type light --platform unix
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
