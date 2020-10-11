{ stdenv, fetchFromGitHub, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-recents";
  version = "2019-11-29";

  src = fetchFromGitHub {
    repo = "gnome-shell-extension-Recents";
    owner = "leonardo-bartoli";
    rev = "c9b9355ba20f45a3449dcca514957665ad9ae442";
    sha256 = "0dlw67vllxamxgijciw021x7vls23jgriiyhyv38j4x99w6ba3xb";
  };

  uuid = "Recents@leonardo.bartoli.gmail.com";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ./ $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Adds an indicator to gnome shell panel to quickly navigate recent open files";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dawidsowa ];
    homepage = "https://github.com/leonardo-bartoli/gnome-shell-extension-Recents";
  };
}
