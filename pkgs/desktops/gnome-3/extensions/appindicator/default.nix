{ lib, stdenv, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-appindicator";
  version = "34";

  src = fetchFromGitHub {
    owner = "Ubuntu";
    repo = "gnome-shell-extension-appindicator";
    rev = "v${version}";
    sha256 = "0p9sk8cv2z242d5783gx2m4l1x9vg5fy1a7yr1wcfshvajlrj23m";
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
    platforms = gnome3.gnome-shell.meta.platforms;
    homepage = "https://github.com/Ubuntu/gnome-shell-extension-appindicator";
  };
}
