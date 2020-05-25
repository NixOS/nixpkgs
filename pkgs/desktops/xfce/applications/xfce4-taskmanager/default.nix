{ lib, mkXfceDerivation, exo, gtk3, libwnck3, libXmu }:

mkXfceDerivation {
  category = "apps";
  pname = "xfce4-taskmanager";
  version = "1.2.3";

  sha256 = "0818chns7vkvjqakgz8z790adkygcq4jlw59dv6kyzk17hxq6cxv";

  nativeBuildInputs = [ exo ];
  buildInputs = [ gtk3 libwnck3 libXmu ];

  meta = {
    description = "Easy to use task manager for Xfce";
  };
}
