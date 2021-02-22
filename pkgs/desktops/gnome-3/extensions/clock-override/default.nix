{ lib, stdenv, fetchzip, gnome3, gettext, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-clock-override";
  version = "12";

  src = fetchzip {
    url = "https://extensions.gnome.org/extension-data/clock-overridegnomeshell.kryogenix.org.v${version}.shell-extension.zip";
    sha256 = "1cyaszks6bwnbgacqsl1pmr24mbj05mad59d4253la9am8ibb4m6";
    stripRoot = false;
  };

  uuid = "clock-override@gnomeshell.kryogenix.org";

  nativeBuildInputs = [ gettext glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict --targetdir=schemas schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r {convenience.js,extension.js,format.js,locale,metadata.json,prefs.js,schemas} $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Customize the date and time format displayed in clock in the top bar in GNOME Shell";
    license = licenses.mit;
    maintainers = with maintainers; [ rhoriguchi ];
    homepage = "https://github.com/stuartlangridge/gnome-shell-clock-override";
    broken = versionOlder gnome3.gnome-shell.version "3.18";
  };
}
