{ stdenv
, fetchFromGitHub
, nix-update-script
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-mpris-indicator-button-unstable";
  version = "2020-03-21";

  src = fetchFromGitHub {
    owner = "JasonLG1979";
    repo = "gnome-shell-extension-mpris-indicator-button";
    rev = "de54160e7d905b8c48c0fe30a437f7c51efc1aa3";
    sha256 = "0n5qlx51fxjq1nn10zhdwfy905j20sv7pwh2jc6fns757ac4pwwk";
  };

  uuid = "mprisindicatorbutton@JasonLG1979.github.io";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "gnomeExtensions.${pname}";
    };
  };


  meta = with stdenv.lib; {
    description = "A simple MPRIS indicator button for GNOME Shell";
    license = licenses.gpl3;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = gnome3.gnome-shell.meta.platforms;
    homepage = "https://github.com/JasonLG1979/gnome-shell-extension-mpris-indicator-button";
    broken = versionOlder gnome3.gnome-shell.version "3.34";
  };
}
