{ stdenv, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-appindicator";
  version = "33";

  src = fetchFromGitHub {
    owner = "Ubuntu";
    repo = "gnome-shell-extension-appindicator";
    rev = "v${version}";
    sha256 = "B039bgg5b63oaHp1Z36k9Dh5FLr8fmfxI25ZgIA+p2I=";
  };

  # This package has a Makefile, but it's used for building a zip for
  # publication to extensions.gnome.org. Disable the build phase so
  # installing doesn't build an unnecessary release.
  dontBuild = true;

  uuid = "appindicatorsupport@rgcjonas.gmail.com";
  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp *.js $out/share/gnome-shell/extensions/${uuid}
    cp -r interfaces-xml $out/share/gnome-shell/extensions/${uuid}
    cp metadata.json $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "AppIndicator/KStatusNotifierItem support for GNOME Shell";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jonafato ];
    platforms = gnome3.gnome-shell.meta.platforms;
    homepage = "https://github.com/Ubuntu/gnome-shell-extension-appindicator";
  };
}
