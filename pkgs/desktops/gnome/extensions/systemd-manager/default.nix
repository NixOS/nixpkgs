{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  glib,
}:

stdenvNoCC.mkDerivation rec {
  pname = "gnome-shell-extension-systemd-manager";
  version = "16";

  # Upstream doesn't post new versions in extensions.gnome.org anymore, see also:
  # https://github.com/hardpixel/systemd-manager/issues/19
  src = fetchFromGitHub {
    owner = "hardpixel";
    repo = "systemd-manager";
    rev = "v${version}";
    hash = "sha256-JecSIRj582jJWdrCQYBWFRkIhosxRhD3BxSAy8/0nVw=";
  };

  nativeBuildInputs = [ glib ];

  postInstall = ''
    rm systemd-manager@hardpixel.eu/schemas/gschemas.compiled
    glib-compile-schemas systemd-manager@hardpixel.eu/schemas

    mkdir -p $out/share/gnome-shell/extensions
    mv systemd-manager@hardpixel.eu $out/share/gnome-shell/extensions
  '';

  passthru = {
    extensionUuid = "systemd-manager@hardpixel.eu";
    extensionPortalSlug = "systemd-manager";
  };

  meta = with lib; {
    description = "GNOME Shell extension to manage systemd services";
    homepage = "https://github.com/hardpixel/systemd-manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linsui ];
  };
}
