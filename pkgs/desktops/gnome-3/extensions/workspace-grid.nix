{ stdenv, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  name = "gnome-shell-workspace-grid-${version}";
  version = "0f3a430e7d04bb5465a17c1225aab0f574426d6b";

  src = fetchFromGitHub {
    owner = "zakkak";
    repo = "workspace-grid-gnome-shell-extension";
    rev = version;
    sha256 = "0503b7lmydrbblfvf9b56pv5hpmykzgyc6v8y99rckg58h2jhs69";
  };

  buildInputs = [
    glib
  ];

  installPhase = ''
    cp -r ${uuid} $out
  '';

  uuid = "workspace-grid@mathematical.coffee.gmail.com";

  meta = with stdenv.lib; {
    description = "Arranges workspaces in a configurable grid";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aneeshusa ];
    homepage = https://github.com/zakkak/workspace-grid-gnome-shell-extension;
  };
}
