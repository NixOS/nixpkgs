{ stdenv, fetchFromGitHub, meson, ninja, python3, gtk3 }:

stdenv.mkDerivation rec {
  name = "elementary-icon-theme-${version}";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "icons";
    rev = version;
    sha256 = "1rw924b3ixfdff368dpv4vgsykwncmrvj9a6yfss0cf236xnvr9b";
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
