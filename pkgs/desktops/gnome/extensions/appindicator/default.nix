{ lib, stdenv, fetchFromGitHub, gnome }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-appindicator";
  version = "37";

  src = fetchFromGitHub {
    owner = "Ubuntu";
    repo = "gnome-shell-extension-appindicator";
    rev = "v${version}";
    sha256 = "1yss91n94laakzhym409iyjs5gwhln2pkq0zrdrsxc3z70zlslxl";
  };

  # This package has a Makefile, but it's used for building a zip for
  # publication to extensions.gnome.org. Disable the build phase so
  # installing doesn't build an unnecessary release.
  dontBuild = true;

  uuid = "appindicatorsupport@rgcjonas.gmail.com";
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp *.js $out/share/gnome-shell/extensions/${uuid}
    cp -r interfaces-xml $out/share/gnome-shell/extensions/${uuid}
    cp metadata.json $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with lib; {
    description = "AppIndicator/KStatusNotifierItem support for GNOME Shell";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jonafato ];
    platforms = gnome.gnome-shell.meta.platforms;
    homepage = "https://github.com/Ubuntu/gnome-shell-extension-appindicator";
  };
}
