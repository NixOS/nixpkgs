{ lib, stdenv, gnome, fetchFromGitHub, xprop, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-unite";
  version = "55";

  src = fetchFromGitHub {
    owner = "hardpixel";
    repo = "unite-shell";
    rev = "v${version}";
    sha256 = "0bav4vzky3p7np2gphxc6bw38c697kalmaibaar9vi0ip3xkkavk";
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
