{ stdenv, fetchFromGitHub, meson, ninja, python3, gtk3 }:

stdenv.mkDerivation rec {
  name = "elementary-icon-theme-${version}";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "icons";
    rev = version;
    sha256 = "12j582f0kggv2lp935r75xg7q26zpl0f05s11xcs4qxazhj1ly2r";
  };

  nativeBuildInputs = [ meson ninja python3 gtk3 ];

  # Disable installing gimp and inkscape palette files
  mesonFlags = [
    "-Dpalettes=false"
  ];

  postPatch = ''
    chmod +x meson/symlink.py
    patchShebangs .
    sed -i volumeicon/meson.build -e "s,'/','$out',"
  '';

  postFixup = ''
    gtk-update-icon-cache $out/share/icons/elementary
  '';

  meta = with stdenv.lib; {
    description = "Icons from the Elementary Project";
    homepage = https://github.com/elementary/icons;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ simonvandel ];
  };
}
