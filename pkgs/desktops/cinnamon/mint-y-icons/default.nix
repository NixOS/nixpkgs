{ fetchFromGitHub
, stdenv
, gnome3
, hicolor-icon-theme
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "mint-y-icons";
  version = "unstable-2020-03-21";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = "f169a617bc344cb0b480b2b72f54cdd06af05255";
    sha256 = "1c2a79ylk363i982czwwqcwc7cw6dyzlqphcypqm6nll7xlafq8s";
  };

  propagatedUserEnvPkgs = [
    gnome3.adwaita-icon-theme
    hicolor-icon-theme
  ];

  nativeBuildInputs = [
    gtk3
  ];

  postFixup =  ''
    gtk-update-icon-cache $out/share/icons/*
  '';

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out
    mv usr/share $out
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/mint-y-icons";
    description = "The Mint-Y icon theme";
    license = licenses.gpl3; # from debian/copyright
    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
