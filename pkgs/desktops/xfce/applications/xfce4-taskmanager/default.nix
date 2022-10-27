{ lib, mkXfceDerivation, exo, gtk3, libwnck, libXmu }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-taskmanager";
  version = "1.4.2";

  sha256 = "sha256-jcICXPtG/7t0U0xqgvU52mjiA8wsyw7JQ0OmNjwA89A=";

  nativeBuildInputs = [ exo ];
  buildInputs = [ gtk3 libwnck libXmu ];

  meta = with lib; {
    description = "Easy to use task manager for Xfce";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
  };
}
