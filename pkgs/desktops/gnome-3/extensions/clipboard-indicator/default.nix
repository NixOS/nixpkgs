{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-clipboard-indicator";
  version = "34";

  src = fetchFromGitHub {
    owner = "Tudmotu";
    repo = "gnome-shell-extension-clipboard-indicator";
    rev = "v${version}";
    sha256 = "0i00psc1ky70zljd14jzr627y7nd8xwnwrh4xpajl1f6djabh12s";
  };

  uuid = "clipboard-indicator@tudmotu.com";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r * $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Adds a clipboard indicator to the top panel and saves clipboard history";
    license = licenses.mit;
    maintainers = with maintainers; [ jonafato ];
    platforms = platforms.linux;
    homepage = "https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator";
  };
}
