{ mkXfceDerivation, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfconf";
  version = "4.14pre1";
  rev = "xfce-4.14pre1";

  sha256 = "0n9cjiz3mj011p3w4jv0n2ifz38whmykdl888mczc26l1gflxnr3";

  buildInputs = [ libxfce4util ];
}
