{ lib, stdenv
, fetchFromGitHub
, sassc
, meson
, ninja
, pkg-config
, gtk3
, gnome
, gtk-engine-murrine
, optipng
, inkscape
, cinnamon
}:

stdenv.mkDerivation rec {
  pname = "arc-theme";
  version = "20210412";

  src = fetchFromGitHub {
    owner = "jnsh";
    repo = pname;
    rev =  version;
    sha256 = "BNJirtBtdWsIzQfsJsZzg1zFbJEzZPq1j2qZ+1QjRH8=";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sassc
    optipng
    inkscape
    gtk3
    cinnamon.cinnamon-common
    gnome.gnome-shell
  ];

  propagatedUserEnvPkgs = [
    gnome.gnome-themes-extra
    gtk-engine-murrine
  ];

  enableParallelBuilding = true;

  preBuild = ''
    # Shut up inkscape's warnings about creating profile directory
    export HOME="$NIX_BUILD_ROOT"
  '';

  postInstall = ''
    install -Dm644 -t $out/share/doc/${pname} $src/AUTHORS $src/*.md
  '';

  meta = with lib; {
    description = "Flat theme with transparent elements for GTK 3, GTK 2 and Gnome Shell";
    homepage = "https://github.com/jnsh/arc-theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ simonvandel romildo ];
  };
}
