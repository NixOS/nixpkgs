{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-window-is-ready-remover";
  version = "1.02";

  src = fetchFromGitHub {
    owner = "nunofarruca";
    repo = "WindowIsReady_Remover";
    rev = "v${version}";
    sha256 = "1xaf95gn0if44avvkjxyf8fl29y28idn9shnrks0m9k67jcwv8ns";
  };

  uuid = "windowIsReady_Remover@nunofarruca@gmail.com";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r ${uuid} $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "GNOME Shell extension removing window is ready notification";
    homepage = "https://github.com/nunofarruca/WindowIsReady_Remover";
    license = licenses.asl20;
  };
}
