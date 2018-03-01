{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extension-appindicator-${version}";
  version = "22";

  src = fetchFromGitHub {
    owner = "Ubuntu";
    repo = "gnome-shell-extension-appindicator";
    rev = "v${version}";
    sha256 = "1gqw54d55hxjj2hh04p0dx2j40bhi4ck9hgwlz8f7j4v7r37z0qw";
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
    homepage = https://github.com/Ubuntu/gnome-shell-extension-appindicator;
  };
}
