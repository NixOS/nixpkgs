{ stdenv, fetchFromGitHub, substituteAll, gjs, vte }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-drop-down-terminal";
  version = "24";

  src = fetchFromGitHub {
    owner = "zzrough";
    repo = "gs-extensions-drop-down-terminal";
    rev = "v${version}";
    sha256 = "1gda56xzwsa5pgmgpb7lhb3i3gqishvn84282inwvqm86afks73r";
  };

  uuid = "drop-down-terminal@gs-extensions.zzrough.org";

  patches = [
    (substituteAll {
      src = ./fix_vte_and_gjs.patch;
      inherit gjs vte;
    })
  ];

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions/
  '';

  meta = with stdenv.lib; {
    description = "Configurable drop down terminal shell";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ericdallo ];
    homepage = https://github.com/zzrough/gs-extensions-drop-down-terminal;
  };
}
