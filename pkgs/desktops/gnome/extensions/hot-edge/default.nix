{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-hot-edge";
  version = "jdoda";

  src = fetchFromGitHub {
    owner = "jdoda";
    repo = "hotedge";
    rev = "bb7f651becea5287241caf7cda246a68ab07dac8";
    sha256 = "oeTs0kRan6b5relxzhK1IKbV0Yv2d5YdvvUPJ3fM9ik=";
  };

  dontBuild = true;

  uuid = "hotedge@jonathan.jdoda.ca";

  installPhase = ''
    runHook preInstall
    install -Dt $out/share/gnome-shell/extensions/${uuid} extension.js metadata.json stylesheet.css
    runHook postInstall
  '';

  meta = with lib; {
    description = "Replace the top-left hot corner with a bottom hot edge";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jtojnar ];
    homepage = "https://github.com/jdoda/hotedge";
  };
}
