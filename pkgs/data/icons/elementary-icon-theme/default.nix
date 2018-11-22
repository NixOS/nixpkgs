{ stdenv, fetchFromGitHub, meson, ninja, python3, gtk3 }:

stdenv.mkDerivation rec {
  name = "elementary-icon-theme-${version}";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "icons";
    rev = version;
    sha256 = "146s26q4bb5sag35iv42hrnbdciam2ajl7s5s5jayli5vp8bw08w";
  };

  nativeBuildInputs = [ meson ninja python3 gtk3 ];

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
