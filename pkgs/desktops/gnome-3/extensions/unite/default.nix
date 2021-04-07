{ lib, stdenv, gnome3, fetchFromGitHub, xprop, glib }:
stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-unite";
  version = "48";

  src = fetchFromGitHub {
    owner = "hardpixel";
    repo = "unite-shell";
    rev = "v${version}";
    sha256 = "1rc9h7zrg9pvyl619ychcp0w7wmnf4ndaq2knv490kzhy0idj18j";
  };

  uuid = "unite@hardpixel.eu";

  nativeBuildInputs = [ glib ];

  buildInputs = [ xprop ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict --targetdir=${uuid}/schemas/ ${uuid}/schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description = "Unite is a GNOME Shell extension which makes a few layout tweaks to the top panel and removes window decorations to make it look like Ubuntu Unity Shell";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ rhoriguchi ];
    homepage = "https://github.com/hardpixel/unite-shell";
    broken = versionOlder gnome3.gnome-shell.version "3.32";
  };
}
