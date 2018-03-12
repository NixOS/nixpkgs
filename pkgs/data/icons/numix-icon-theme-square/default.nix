{ stdenv, fetchFromGitHub, gtk3, numix-icon-theme }:

stdenv.mkDerivation rec {
  name = "${package-name}-${version}";
  package-name = "numix-icon-theme-square";
  version = "18-02-16";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = version;
    sha256 = "1gjwc0s6a7q1jby5bcwxkcmbs470m81y8s0clsm0qhcmcn1c36xj";
  };

  nativeBuildInputs = [ gtk3 numix-icon-theme ];

  installPhase = ''
    mkdir -p $out/share/icons
    cp -a Numix-Square{,-Light} $out/share/icons/
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Numix icon theme (square version)";
    homepage = https://numixproject.org;
    license = licenses.gpl3;
    platforms = with platforms; allBut darwin;
    maintainers = with maintainers; [ romildo ];
  };
}
