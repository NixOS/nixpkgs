{ stdenv, fetchFromGitHub, gtk3 }:

stdenv.mkDerivation rec {
  pname = "qogir-icon-theme";
  version = "2019-09-15";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = "4e1b6c693615bc2c7c7a11df6f4b90f2e6fb67db";
    sha256 = "1vp1wp4fgmy5af8z8nb3m6wgmb6wbwlvx5smf9dxfcn254hdg8g0";
  };

  nativeBuildInputs = [ gtk3 ];

  installPhase = ''
    patchShebangs install.sh
    mkdir -p $out/share/icons
    name= ./install.sh -d $out/share/icons
  '';

  meta = with stdenv.lib; {
    description = "A colorful design icon theme for linux desktops";
    homepage = https://github.com/vinceliuice/Qogir-icon-theme;
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
