{ mkXfceDerivation, exo, gtk3, libwnck3, libXmu }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-taskmanager";
  version = "1.4.2";

  sha256 = "1l7k00y3d9j38g4hxjrcrh1y4s6s77sq4sjcadsbpzs6zdf05hld";

  nativeBuildInputs = [ exo ];
  buildInputs = [ gtk3 libwnck3 libXmu ];

  meta = {
    description = "Easy to use task manager for Xfce";
  };
}
