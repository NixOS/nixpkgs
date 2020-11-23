{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-clipboard-indicator";
  version = "37";

  src = fetchFromGitHub {
    owner = "Tudmotu";
    repo = "gnome-shell-extension-clipboard-indicator";
    rev = "v${version}";
    sha256 = "0npxhaam2ra2b9zh2gk2q0n5snlhx6glz86m3jf8hz037w920k41";
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
