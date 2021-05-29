{ lib, stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-freon";
  version = "44";

  passthru = {
    extensionUuid = "freon@UshakovVasilii_Github.yahoo.com";
    extensionPortalSlug = "freon";
  };

  src = fetchFromGitHub {
    owner = "UshakovVasilii";
    repo = "gnome-shell-extension-freon";
    rev = "EGO-${version}";
    sha256 = "sha256-4DYAIC9N5id3vQe0WaOFP+MymsrPK18hbYqO4DjG+2U=";
  };

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict --targetdir="freon@UshakovVasilii_Github.yahoo.com/schemas" "freon@UshakovVasilii_Github.yahoo.com/schemas"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r "freon@UshakovVasilii_Github.yahoo.com" $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description = "GNOME Shell extension for displaying CPU, GPU, disk temperatures, voltage and fan RPM in the top panel";
    license = licenses.gpl2;
    maintainers = with maintainers; [ justinas ];
    homepage = "https://github.com/UshakovVasilii/gnome-shell-extension-freon";
  };
}
