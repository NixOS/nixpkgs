{ mkXfceDerivation, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfconf";
  version = "4.13.4";

  sha256 = "1bm4q06rwlmkmcy6qnwm6l70w6749iqfrmsrgj3y1jb2sacc3pd4";

  buildInputs = [ libxfce4util ];
}
