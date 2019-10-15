{ stdenv
, fetchFromGitHub
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-mpris-indicator-button-unstable";
  version = "2019-09-29";

  src = fetchFromGitHub {
    owner = "JasonLG1979";
    repo = "gnome-shell-extension-mpris-indicator-button";
    rev = "6cdc28a8bde98f25618b27ee48280996e2b4a0f8";
    sha256 = "1n3sh3phpa75y3vpc09wnzhis0m92zli1m46amzsdbvmk6gkifif";
  };

  uuid = "mprisindicatorbutton@JasonLG1979.github.io";

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions
  '';

  meta = with stdenv.lib; {
    description = "A simple MPRIS indicator button for GNOME Shell";
    license = licenses.gpl3;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = gnome3.gnome-shell.meta.platforms;
    homepage = "https://github.com/JasonLG1979/gnome-shell-extension-mpris-indicator-button";
    broken = versionOlder gnome3.gnome-shell.version "3.34";
  };
}
