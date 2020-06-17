{ mkXfceDerivation, libxfce4util }:

mkXfceDerivation {
  category = "xfce";
  pname = "xfconf";
  version = "4.14.3";

  sha256 = "0yxpdcyz81di7w9493jzps09bgrlgianjj5abnzahqmkpmpvb0rh";

  buildInputs = [ libxfce4util ];

  meta = {
    description = "Simple client-server configuration storage and query system for Xfce";
  };
}
