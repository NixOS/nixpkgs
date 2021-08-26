{ lib, stdenv, gnome, fetchFromGitHub, xprop, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-unite";
  version = "54";

  src = fetchFromGitHub {
    owner = "hardpixel";
    repo = "unite-shell";
    rev = "v${version}";
    sha256 = "sha256-Ys2kWPj/FugW/LkvLAZdbj7Ufg/KShC+EX6QrjKNVH8=";
  };

  passthru = {
    extensionUuid = "unite@hardpixel.eu";
    extensionPortalSlug = "unite";
  };

  nativeBuildInputs = [ glib ];

  buildInputs = [ xprop ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict --targetdir="unite@hardpixel.eu/schemas/" "unite@hardpixel.eu/schemas"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r "unite@hardpixel.eu" $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description = "Unite is a GNOME Shell extension which makes a few layout tweaks to the top panel and removes window decorations to make it look like Ubuntu Unity Shell";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ rhoriguchi ];
    homepage = "https://github.com/hardpixel/unite-shell";
    broken = versionOlder gnome.gnome-shell.version "3.32";
  };
}
