{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-clipboard-indicator";
  version = "30";

  src = fetchFromGitHub {
    owner = "Tudmotu";
    repo = "gnome-shell-extension-clipboard-indicator";
    rev = "v${version}";
    sha256 = "1fmgmxv2y678bj0kmymkgnnglcpqk8ww053izlq46xg7s27jjdf6";
  };

  uuid = "clipboard-indicator@tudmotu.com";

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r * $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "Adds a clipboard indicator to the top panel and saves clipboard history";
    license = licenses.mit;
    maintainers = with maintainers; [ jonafato ];
    platforms = platforms.linux;
    homepage = https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator;
  };
}
