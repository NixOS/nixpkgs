{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-pixel-saver-${version}";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "deadalnix";
    repo = "pixel-saver";
    rev = version;
    sha256 = "040ayzhpv9jq49vp32w85wvjs57047faa7872qm4brii450iy7v4";
  };

  uuid = "pixel-saver@deadalnix.me";

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
  '';

  meta = with stdenv.lib; {
    description = "Pixel Saver is designed to save pixel by fusing activity bar and title bar in a natural way";
    license = licenses.mit;
    maintainers = with maintainers; [ jonafato ];
    platforms = platforms.linux;
    homepage = https://github.com/deadalnix/pixel-saver;
  };
}
