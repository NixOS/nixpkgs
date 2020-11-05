{ stdenv, fetchFromGitHub, gtk3, gnome-themes-extra }:
stdenv.mkDerivation rec {
  pname = "reversal-icon-theme";
  version = "unstable-2020-10-31";

  src = fetchFromGitHub {
    repo = "Reversal-icon-theme";
    owner = "yeyushengfan258";
    rev = "fb6cb29e02991915931cf1ed9b88d5257f177ed2";
    sha256 = "15vml083kd40hzfb6s1f5xndwqz6ys58sg076cvpz9vsbxhwbjnl";
  };

  nativeBuildInputs = [ gtk3 ];

  buildInputs = [ gnome-themes-extra ];

  patchPhase = ''patchShebangs install.sh'';

  installPhase = ''
    mkdir -p $out/share/icons
    ./install.sh --dest $out/share/icons
  '';

  meta = with stdenv.lib; {
    description = "Reversal icon theme";
    homepage = "https://github.com/yeyushengfan258/Reversal-icon-theme";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ icy-thought ];
  };
}
