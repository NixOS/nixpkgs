{ stdenv, fetchFromGitHub, substituteAll, gjs, vte, gnome3 }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-drop-down-terminal";
  version = "unstable-2020-03-25";

  src = fetchFromGitHub {
    owner = "zzrough";
    repo = "gs-extensions-drop-down-terminal";
    rev = "a59669afdb395b3315619f62c1f740f8b2f0690d";
    sha256 = "0igfxgrjdqq6z6xg4rsawxn261pk25g5dw2pm3bhwz5sqsy4bq3i";
  };

  uuid = "drop-down-terminal@gs-extensions.zzrough.org";

  patches = [
    (substituteAll {
      src = ./fix_vte_and_gjs.patch;
      inherit gjs vte;
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions/
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Configurable drop down terminal shell";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ericdallo ];
    homepage = "https://github.com/zzrough/gs-extensions-drop-down-terminal";
  };
}
